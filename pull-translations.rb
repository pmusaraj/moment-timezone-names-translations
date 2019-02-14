require 'nokogiri'
require 'open-uri'
require 'json'

args = {}

ARGV.each do |arg|
  match = /--(?<key>.*?)=(?<value>.*)/.match(arg)
  args[match[:key]] = match[:value]
end

lang = args['language']

if lang.nil?
  puts "ERROR: missing language argument. Specify as language=fr, for example."
  exit 1
end

if lang == 'en'
  puts "ERROR: no need to translate EN strings."
  exit 1
end

xml_source = "https://unicode.org/repos/cldr/trunk/common/main/#{lang}.xml"

start = Time.now

doc = Nokogiri::XML(open(xml_source)) do |config|
  config.options = Nokogiri::XML::ParseOptions::NOBLANKS
end

data = JSON.parse(File.read("en.json"))

content = <<~JS
  // moment-timezone-localization for lang code: #{lang}

  ;(function (global, factory) {
     typeof exports === 'object' && typeof module !== 'undefined'
         && typeof require === 'function' ? factory(require('../moment')) :
     typeof define === 'function' && define.amd ? define(['../moment'], factory) :
     factory(global.moment)
  }(this, (function (moment) { 'use strict';

JS

output = []
data['timeZoneNames'].each do |name|
  translation = doc.xpath("//zone[@type='#{name}']").text
  if !translation.empty?
    output << { 'value' => name, 'name' => translation, 'id' => name }
  end
end

content += <<~JS

  moment.tz.localizedNames = function() {
    return #{output.to_json};
  };

  return moment;
  })));
JS

File.write("locales/#{lang}.js", content)

STDERR.puts "Completed preparing #{lang} translations: #{(Time.now - start).round(2)} secs"

