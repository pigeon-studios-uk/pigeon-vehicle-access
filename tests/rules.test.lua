--[[
    Tests for server/rules.lua.

    Run from the repository root with Lua 5.4:
        lua tests/rules.test.lua
]]

local Rules = dofile('server/rules.lua')
dofile('locales/en.lua')

local passed, failed = 0, 0
local function check(name, ok, detail)
    if ok then
        passed = passed + 1
    else
        failed = failed + 1
        io.write(('  \27[31mFAIL\27[0m  %s%s\n'):format(name, detail ~= nil and ('\n          ' .. tostring(detail)) or ''))
    end
end

local function t(key, values)
    return (Locales.en[key]:gsub('{(%w+)}', function(name) return tostring(values and values[name]) end))
end

io.write('Pigeon Vehicle Access rules tests\n')

---------------------------------------------------------------------------
-- Model hashes (known values from GTA V)

check('hash adder', Rules.hash('adder') == -1216765807, Rules.hash('adder'))
check('hash police', Rules.hash('police') == 2046537925, Rules.hash('police'))
check('hash police3', Rules.hash('police3') == 1912215274, Rules.hash('police3'))
check('hash is case-insensitive', Rules.hash('ADDER') == Rules.hash('adder'))
check('hash is a signed 32-bit number', Rules.hash('t20') == 1663218586 and Rules.hash('zentorno') == -1403128555, Rules.hash('t20') .. ' ' .. Rules.hash('zentorno'))

---------------------------------------------------------------------------
-- Compiling config

local rules, problems = Rules.compile({
    police3 = { label = 'Interceptor', jobs = { police = 2, sheriff = 0 }, onDuty = true },
    adder = { whitelist = true },
    buffalo = { gangs = { ballas = 1 }, ace = 'vehicle.buffalo' },
    nothing = {},
    broken = { jobs = { police = 'two' } },
    ['bad name!'] = { whitelist = true },
    notatable = true,
})

check('valid rules are keyed by hash', rules[Rules.hash('police3')] and rules[Rules.hash('adder')] and rules[Rules.hash('buffalo')])
check('label kept, model lower-cased', rules[Rules.hash('police3')].label == 'Interceptor' and rules[Rules.hash('adder')].label == 'adder')
check('four problems reported', #problems == 4, table.concat(problems, ' | '))
local all = table.concat(problems, '\n')
check('empty rule is skipped with a reason', all:find("'nothing'%] has no jobs") ~= nil)
check('bad grade map is explained', all:find("'broken'%]%.jobs must look like") ~= nil)
check('bad model name is explained', all:find('spawn name') ~= nil)
check('non-table rule is explained', all:find("'notatable'%]: must be a table") ~= nil)

---------------------------------------------------------------------------
-- Evaluating

local police3 = rules[Rules.hash('police3')]
local adder = rules[Rules.hash('adder')]
local buffalo = rules[Rules.hash('buffalo')]
local none = {}

local officer = { jobs = { police = 3 }, primaryJob = 'police', onDuty = true }
local cadet = { jobs = { police = 1 }, primaryJob = 'police', onDuty = true }
local offDuty = { jobs = { police = 3 }, primaryJob = 'police', onDuty = false }
local deputy = { jobs = { sheriff = 0 }, primaryJob = 'sheriff', onDuty = true }
local civilian = { jobs = { unemployed = 0 }, primaryJob = 'unemployed', onDuty = false }
local secondJob = { jobs = { mechanic = 0, police = 4 }, primaryJob = 'mechanic', onDuty = true }
local baller = { jobs = {}, gang = 'ballas', gangGrade = 2 }
local recruit = { jobs = {}, gang = 'ballas', gangGrade = 0 }

local function eval(rule, player, checks) local ok, why = Rules.evaluate(rule, player, checks or none) return ok, why end

check('job with high enough grade, on duty: allowed', select(2, eval(police3, officer)) == 'job')
check('job with too low a grade: denied', not eval(police3, cadet))
check('grade 0 minimum allows every grade', eval(police3, deputy))
check('off duty when onDuty is required: denied', not eval(police3, offDuty))
check('someone without the job: denied (unlike the old Vehicle Lock)', not eval(police3, civilian))
check('onDuty only counts for the job they\'re clocked into', not eval(police3, secondJob))
local noDuty = Rules.compile({ x = { jobs = { police = 2 } } })[Rules.hash('x')]
check('without onDuty, a second job counts', eval(noDuty, secondJob))
check('gang with high enough grade: allowed', select(2, eval(buffalo, baller)) == 'gang')
check('gang grade too low: denied', not eval(buffalo, recruit))
check('ACE permission: allowed', select(2, eval(buffalo, civilian, { ace = function(name) return name == 'vehicle.buffalo' end })) == 'ace')
check('whitelist: allowed when whitelisted', select(2, eval(adder, civilian, { whitelisted = function() return true end })) == 'whitelist')
check('whitelist: denied when not', not eval(adder, civilian, { whitelisted = function() return false end }))
check('bypass ACE: always allowed', select(2, eval(adder, civilian, { bypass = function() return true end })) == 'bypass')
check('no player data (framework missing): only ACE/whitelist can allow', not eval(police3, nil))

local calls = 0
eval(police3, officer, { whitelisted = function() calls = calls + 1 return true end })
check('the database isn\'t asked when a job already allows it', calls == 0)

---------------------------------------------------------------------------
-- Describing

check('describe jobs on duty with grades', Rules.describe(police3, t) == 'on-duty police (grade 2+), sheriff', Rules.describe(police3, t))
check('describe gangs or ACE', Rules.describe(buffalo, t) == 'ballas (grade 1+), or staff with permission', Rules.describe(buffalo, t))
check('describe whitelist', Rules.describe(adder, t) == 'whitelisted drivers')

---------------------------------------------------------------------------
-- Admin "who" argument

local function who(text) local w = Rules.parseWho(text) return w and (w.kind .. '=' .. tostring(w.value)) or 'nil' end
check('server ID', who('12') == 'server=12')
check('citizen ID', who('ABC12345') == 'citizenid=ABC12345')
check('discord ID', who('discord:123456789012345678') == 'discord=discord:123456789012345678')
check('rubbish rejected', who('drop table;') == 'nil' and who('') == 'nil' and who('discord:abc') == 'nil')
check('long numbers are citizen IDs, not server IDs', who('12345678') == 'citizenid=12345678')

check('rules exposed as VehicleAccessRules', VehicleAccessRules == Rules)

io.write(('%d passed, %d failed\n'):format(passed, failed))
os.exit(failed == 0 and 0 or 1)
