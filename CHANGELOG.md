# Changelog

All notable changes to Pigeon Vehicle Access are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project uses [Semantic Versioning](https://semver.org/spec/v2.0.0.html):

- **Major** versions can need changes to your configuration or other resources. Read the **Upgrade notes**.
- **Minor** versions add features without breaking existing setups.
- **Patch** versions fix bugs only.

## [Unreleased]

## [1.0.0] - 2026-10-18

First release. Pigeon Vehicle Access replaces Vehicle Lock (`vehicle-lock`).

### Upgrade notes

- Coming from Vehicle Lock: remove `vehicle-lock`, install this, and move your vehicles into the new `Config.Vehicles` format.
- A job rule now means only that job can drive the vehicle. Vehicle Lock let players without the job drive it.
- Whitelists are in the new `pigeon_vehicle_access` table. The README has SQL to copy old entries across.
- OneSync is required.

### Added

- Rules per vehicle by job and lowest grade, on duty, gang and grade, ACE permission and whitelist, in any combination.
- Server-side checks of who is driving, which players can't hide or skip.
- Taking drivers out of a vehicle if it keeps moving after they've been stopped.
- Messages saying who a vehicle is for.
- In-game whitelist management with `/vehicleaccess add`, `remove`, `list`, `check` and `rules`, by server ID, citizen ID or Discord ID, with notes.
- A staff bypass ACE.
- Qbox support including multiple jobs, and QBCore support.
- `CanDrive`, `AddToWhitelist` and `RemoveFromWhitelist` exports.
- Every message in `locales/`.
- Update checker from the Pigeon Studios version registry.
- Tests for the rules, the server and the client in plain Lua 5.4, and for every query against MariaDB 10.6 and 11.4.

### Fixed (compared with Vehicle Lock)

- Vehicles are matched by spawn name. Vehicle Lock used the display name, so many add-on vehicles were never matched.
- Framework detection works. Vehicle Lock always used qb-core.
- Whitelists use the standard oxmysql. Vehicle Lock needed a renamed copy of it.
- Vehicles are made driveable again when a stopped player gets out. In Vehicle Lock they could stay undriveable for the next driver.

[Unreleased]: https://github.com/WelshPigeon/pigeon-vehicle-access/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/WelshPigeon/pigeon-vehicle-access/releases/tag/v1.0.0
