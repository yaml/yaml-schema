require('testml/bridge')
require('ingy-prelude')
yaml = require('yaml')
util = require('util')

class TestMLBridge extends TestML.Bridge
  compile: (schema)->
    Compiler = require('../lib/yaml-schema-compiler')
    compiler = new Compiler
    data = yaml.parse schema
    compiler.compile data

  dump: (object)->
    yaml.stringify object

  inspect: (node)->
    text = util.inspect(node)
      .replace /\n?$/, "\n"

module.exports = TestMLBridge
