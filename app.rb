require 'bundler'
require_relative 'lib/scrapper.rb'

Bundler.require
$:.unshift File.expand_path("./lib/scrapper.rb")#!/usr/bin/env ruby -wKU)

db = Scrapper.new('https://www.annuaire-des-mairies.com/val-d-oise.html')
db.save_as_JSON
db.save_as_spreadsheet
db.save_as_csv