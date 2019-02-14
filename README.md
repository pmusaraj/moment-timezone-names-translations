## Moment Timezone Names Translations

This repository provides translation files for timezone names. It should be mostly used in conjuction with Moment Timezone, as this repository provides a helper function (`moment.tz.localizedNames()`) that supplants a Moment Timezone function (`moment.tz.names()`).

### Usage

Load the language file of your choice from `/locales` and call `moment.tz.localizedNames()`. This will return an array of timezone names as below:

```
{"value":"Africa/Abidjan","name":"أبيدجان","id":"Africa/Abidjan"},
{"value":"Africa/Accra","name":"أكرا","id":"Africa/Accra"},
{"value":"Africa/Addis_Ababa","name":"أديس أبابا","id":"Africa/Addis_Ababa"},
...
{"value":"Pacific/Wallis","name":"واليس","id":"Pacific/Wallis"}
```

### Adding more translations

If you would like to add a missing translation, you can run:

```
ruby pull-translations.rb --language=ar
```

where `ar` is the language code in the Unicode CLDR source: `https://unicode.org/repos/cldr/trunk/common/main/ar.xml`.

### Known limitations

The translations provided by Unicode CLDR do not correspond entirely with the list of timezones used by Moment Timezone. 
