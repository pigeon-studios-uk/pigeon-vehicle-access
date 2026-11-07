--[[
    Pigeon Vehicle Access: Spanish (Español).

    Translated from locales/en.lua, which has the notes on each line. If something reads
    wrong, please send a fix (see the README's Contributing section). Set Config.Locale = 'es'
    to use it, or leave it on 'auto' and set ox_lib's language.
    Keep words in {curly brackets} exactly as they are; they're filled in automatically.
]]

Locales = Locales or {}

Locales.es = {
    title = 'Acceso a vehículos',

    -- Shown to a driver who isn't allowed. {vehicle} is the vehicle's label, {who} says who can drive it.
    denied = 'No tienes autorización para conducir este {vehicle}.',
    denied_who = 'No tienes autorización para conducir este {vehicle}. Es para {who}.',
    denied_help = 'No tienes autorización para conducir este vehículo.',

    -- How {who} is written.
    who_jobs = '{jobs}',
    who_jobs_on_duty = '{jobs} de servicio',
    who_gangs = '{gangs}',
    who_grade = '{name} (rango {grade}+)',
    who_ace = 'staff con permiso',
    who_whitelist = 'conductores en la whitelist',
    who_or = ' o ',

    -- Admin command
    usage = 'Uso: /{command} add <model> <who> [note] | remove <model> <who> | list <model> | check <server ID> <model> | rules',
    who_help = '<who> es un ID de servidor conectado, un citizen ID o discord:<ID>.',
    no_permission = 'No tienes permiso para usar este comando.',
    unknown_model = '"{model}" no está en Config.Vehicles.',
    not_whitelist_model = 'Nota: {model} no tiene whitelist = true, así que las entradas de la whitelist no dejarán conducirlo a nadie hasta que lo añadas.',
    bad_who = '"{who}" no es un ID de servidor, un citizen ID ni discord:<ID>.',
    player_offline = 'No hay ningún jugador conectado con el ID de servidor {id}.',
    added = 'Se añadió {who} a la whitelist de {model}.',
    already = '{who} ya está en la whitelist de {model}.',
    removed = 'Se quitó a {who} de la whitelist de {model}.',
    not_found = '{who} no está en la whitelist de {model}.',
    list_header = 'Whitelist de {model} ({count}):',
    list_entry = '{who}{note} - añadido el {date} por {by}',
    list_empty = 'No hay nadie en la whitelist de {model}.',
    check_result = 'El jugador {id} {result} conducir {model} ({reason}).',
    check_can = 'puede',
    check_cannot = 'no puede',
    rules_header = 'Vehículos restringidos ({count}):',
    rules_entry = '{model} ({label}): {who}',

    -- Console
    started = 'Vigilando {count} vehículos restringidos con {framework}.',
    no_framework = 'No está en marcha ni qbx_core ni qb-core, así que no se pueden comprobar las reglas de trabajos y bandas. Las reglas de ACE y whitelist siguen funcionando.',
    config_problem = 'Problema en la config: {problem}',
    bypass_attempt = 'El jugador {id} ({name}) siguió conduciendo {model} después de ser detenido, así que se le sacó del vehículo.',
}
