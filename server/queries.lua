--[[
    Pigeon Vehicle Access: every database query, in one place.

    Kept separate so the same SQL the server runs is also run against a real MariaDB in CI
    (tests/sql.test.mjs), with every value passed as a parameter, never joined into the SQL.
]]

local Q = {}

Q.TABLE = 'pigeon_vehicle_access'

Q.create = ([[
CREATE TABLE IF NOT EXISTS `%s` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `model` VARCHAR(64) NOT NULL,
    `identifier` VARCHAR(80) NOT NULL,
    `note` VARCHAR(255) NULL DEFAULT NULL,
    `added_by` VARCHAR(80) NULL DEFAULT NULL,
    `added_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `model_identifier` (`model`, `identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci]]):format(Q.TABLE)

--- Is any of these identifiers on this model's whitelist? params: model, then one per identifier.
function Q.isWhitelisted(count)
    return ('SELECT 1 FROM `%s` WHERE `model` = ? AND `identifier` IN (%s) LIMIT 1'):format(Q.TABLE, ('?,'):rep(count):sub(1, -2))
end

-- params: model, identifier, note, added_by
Q.add = ('INSERT IGNORE INTO `%s` (`model`, `identifier`, `note`, `added_by`) VALUES (?, ?, ?, ?)'):format(Q.TABLE)

-- params: model, identifier
Q.remove = ('DELETE FROM `%s` WHERE `model` = ? AND `identifier` = ?'):format(Q.TABLE)

-- params: model
Q.list = ('SELECT `identifier`, `note`, `added_by`, DATE_FORMAT(`added_at`, \'%%Y-%%m-%%d\') AS added_on FROM `%s` WHERE `model` = ? ORDER BY `added_at`, `id` LIMIT 100'):format(Q.TABLE)

VehicleAccessQueries = Q
return Q
