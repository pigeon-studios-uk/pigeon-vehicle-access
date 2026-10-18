/**
 * Runs the exact SQL from server/queries.lua against a real MariaDB and checks the results.
 *
 * CI starts MariaDB as a service. To run it yourself against a throwaway database:
 *     lua tests/dump-queries.lua > queries.json
 *     npm install --no-save mysql2@3.11.3
 *     DB_HOST=127.0.0.1 DB_USER=root DB_PASSWORD=secret node tests/sql.test.mjs
 *
 * It creates and drops its own database (pva_test); never point it at a live server.
 */

import { readFileSync } from 'node:fs';
import mysql from 'mysql2/promise';

const Q = JSON.parse(readFileSync('queries.json', 'utf8'));

let passed = 0;
let failed = 0;
function check(name, ok, detail) {
    if (ok) {
        passed++;
    } else {
        failed++;
        console.log(`  \x1b[31mFAIL\x1b[0m  ${name}${detail !== undefined ? `\n          ${JSON.stringify(detail)}` : ''}`);
    }
}

const db = await mysql.createConnection({
    host: process.env.DB_HOST ?? '127.0.0.1',
    port: Number(process.env.DB_PORT ?? 3306),
    user: process.env.DB_USER ?? 'root',
    password: process.env.DB_PASSWORD ?? '',
    multipleStatements: true,
});

console.log('Pigeon Vehicle Access SQL tests');

await db.query('DROP DATABASE IF EXISTS pva_test; CREATE DATABASE pva_test CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; USE pva_test;');

await db.query(Q.create);
await db.query(Q.create);
check('table can be created again on every start', true);

// Adding
const [first] = await db.query(Q.add, ['adder', 'ABC123', 'Won the raffle', 'console']);
check('add inserts one row', first.affectedRows === 1, first.affectedRows);
const [again] = await db.query(Q.add, ['adder', 'ABC123', 'Different note', 'console']);
check('adding the same person twice changes nothing', again.affectedRows === 0, again.affectedRows);
await db.query(Q.add, ['adder', 'discord:123456789012345678', null, 'some-shop']);
await db.query(Q.add, ['t20', 'ABC123', null, 'console']);
const longNote = 'n'.repeat(255);
const [noteRow] = await db.query(Q.add, ['police3', 'X'.repeat(80), longNote, 'license:' + 'f'.repeat(40)]);
check('longest identifier, note and added_by fit', noteRow.affectedRows === 1);

// Checking
const [[hit]] = await db.query(Q.isWhitelisted_2, ['adder', 'ABC123', 'discord:999']);
check('whitelisted by citizen ID', hit !== undefined, hit);
const [[hitDiscord]] = await db.query(Q.isWhitelisted_2, ['adder', 'NOPE', 'discord:123456789012345678']);
check('whitelisted by Discord ID', hitDiscord !== undefined, hitDiscord);
const [miss] = await db.query(Q.isWhitelisted_1, ['adder', 'NOPE']);
check('not whitelisted returns no rows', miss.length === 0, miss);
const [otherModel] = await db.query(Q.isWhitelisted_1, ['zentorno', 'ABC123']);
check('entries for one model don\'t count for another', otherModel.length === 0, otherModel);
const [caseCheck] = await db.query(Q.isWhitelisted_1, ['adder', 'abc123']);
check('identifiers match case-insensitively (MariaDB default collation)', caseCheck.length === 1, caseCheck);

// Listing
const [list] = await db.query(Q.list, ['adder']);
check('list returns entries in the order added', list.length === 2 && list[0].identifier === 'ABC123' && list[1].identifier === 'discord:123456789012345678', list);
check('list includes note, added_by and a YYYY-MM-DD date', list[0].note === 'Won the raffle' && list[0].added_by === 'console' && /^\d{4}-\d{2}-\d{2}$/.test(list[0].added_on), list[0]);

// Removing
const [removed] = await db.query(Q.remove, ['adder', 'ABC123']);
check('remove deletes one row', removed.affectedRows === 1, removed.affectedRows);
const [removedAgain] = await db.query(Q.remove, ['adder', 'ABC123']);
check('removing again deletes nothing', removedAgain.affectedRows === 0, removedAgain.affectedRows);
const [[stillT20]] = await db.query(Q.isWhitelisted_1, ['t20', 'ABC123']);
check('removing from one model leaves the others', stillT20 !== undefined);

// Parameters are never treated as SQL
const evil = "x' OR '1'='1";
const [injected] = await db.query(Q.isWhitelisted_1, ['adder', evil]);
check('quotes in an identifier are just text', injected.length === 0, injected);

await db.query('DROP DATABASE IF EXISTS pva_test;');
await db.end();

console.log(`${passed} passed, ${failed} failed`);
process.exit(failed === 0 ? 0 : 1);
