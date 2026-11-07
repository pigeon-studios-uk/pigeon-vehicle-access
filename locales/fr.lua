--[[
    Pigeon Vehicle Access: French (Français).

    Translated from locales/en.lua, which has the notes on each line. If something reads
    wrong, please send a fix (see the README's Contributing section). Set Config.Locale = 'fr'
    to use it, or leave it on 'auto' and set ox_lib's language.
    Keep words in {curly brackets} exactly as they are; they're filled in automatically.
]]

Locales = Locales or {}

Locales.fr = {
    title = 'Accès aux véhicules',

    -- Shown to a driver who isn't allowed. {vehicle} is the vehicle's label, {who} says who can drive it.
    denied = 'Vous n\'êtes pas autorisé à conduire ce véhicule ({vehicle}).',
    denied_who = 'Vous n\'êtes pas autorisé à conduire ce véhicule ({vehicle}). Il est réservé à : {who}.',
    denied_help = 'Vous n\'êtes pas autorisé à conduire ce véhicule.',

    -- How {who} is written.
    who_jobs = '{jobs}',
    who_jobs_on_duty = '{jobs} en service',
    who_gangs = '{gangs}',
    who_grade = '{name} (grade {grade}+)',
    who_ace = 'le staff autorisé',
    who_whitelist = 'les conducteurs sur la whitelist',
    who_or = ' ou ',

    -- Admin command
    usage = 'Utilisation: /{command} add <model> <who> [note] | remove <model> <who> | list <model> | check <server ID> <model> | rules',
    who_help = '<who> est un ID serveur connecté, un citizen ID ou discord:<ID>.',
    no_permission = 'Vous n\'avez pas la permission d\'utiliser cette commande.',
    unknown_model = '"{model}" n\'est pas dans Config.Vehicles.',
    not_whitelist_model = 'Remarque : {model} n\'a pas whitelist = true, donc les entrées de la whitelist ne permettront à personne de le conduire tant que vous ne l\'aurez pas ajouté.',
    bad_who = '"{who}" n\'est ni un ID serveur, ni un citizen ID, ni discord:<ID>.',
    player_offline = 'Aucun joueur connecté avec l\'ID serveur {id}.',
    added = '{who} ajouté à la whitelist de {model}.',
    already = '{who} est déjà sur la whitelist de {model}.',
    removed = '{who} retiré de la whitelist de {model}.',
    not_found = '{who} n\'est pas sur la whitelist de {model}.',
    list_header = 'Whitelist de {model} ({count}) :',
    list_entry = '{who}{note} - ajouté le {date} par {by}',
    list_empty = 'Personne n\'est sur la whitelist de {model}.',
    check_result = 'Le joueur {id} {result} conduire {model} ({reason}).',
    check_can = 'peut',
    check_cannot = 'ne peut pas',
    rules_header = 'Véhicules restreints ({count}) :',
    rules_entry = '{model} ({label}) : {who}',

    -- Console
    started = 'Surveillance de {count} véhicules restreints avec {framework}.',
    no_framework = 'Ni qbx_core ni qb-core n\'est lancé, donc les règles de métiers et de gangs ne peuvent pas être vérifiées. Les règles ACE et de whitelist fonctionnent toujours.',
    config_problem = 'Problème dans la config: {problem}',
    bypass_attempt = 'Le joueur {id} ({name}) a continué à conduire {model} après avoir été arrêté, il en a donc été sorti.',
}
