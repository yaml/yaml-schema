class YamlSchemaCompiler
  constructor: ->
    @schema =
      yaml:
        vers: 1.2
        rule: []
      type:
        '/': null
      vars: {}
    @vars = {}
    return

  compile: (node)->
    schema = @make_schema(node)
      .sign_schema()
      .schema

    return schema

  make_schema: (node)->
    if @type(node) != 'map'
      @error 'Top level schema node must be a mapping'

    # Need base imports and vars first:
    if (base = node.base)?
      @make_base base
    else
      @make_base_core()
    if (vars = node.vars)?
      @make_vars vars

    for k, v of node
      if k in ['base', 'vars']
        continue
      switch k
        when 'yaml' then @make_yaml(v)
        when 'type' then @make_type_schema(v)
        when 'root'
          type = @make_type(v)
          @set_root(type)
        when 'pair'
          type = @make_type_map(pair: v)
          @set_root(type)
        when 'list'
          type = @make_type_list(list: v)
          @set_root(type)
        else @error "Unknown key '#{k}' in schema top level"

    return @

  make_base: (node)->
  make_base_core: (node)->
  make_type: (node)->
    f
  make_type_map: (node)->
    type =
      kind: Map
      pair: []
    for k, v of node
      switch k
        when 'kind'
          if v != 'Map'
            @error "Can't make Map type when 'kind' is '#{v}'"
        when 'pair'
          if @type(v) != 'list'
            @error "Value of 'pair' must be a Seq"
          for pair in v
            type.pair.push(@make_pair(v))
        else @error "Unknown key '#{k}' for Map definition"
    return type

  make_pair: (node)->
    pair =
      skey: null
      tkey: null
      tval: null
      need: true

  set_root: (type)->

  sign_schema: ->
    schema = @schema
    sha256 = require 'crypto-js/sha256'
    base64 = require 'crypto-js/enc-base64'
    json   = JSON.stringify(schema, null, 2)
    schema.sign = base64.stringify(sha256(json))
    return @

  type: (node)->
    type = typeof node
    if type == 'string' then 'str'
    else if type == 'number' then 'num'
    else if type == 'boolean' then 'bool'
    else if type == 'function' then 'func'
    else if node == null then 'null'
    else if node instanceof Array then 'list'
    else if node instanceof RegExp then 'rgx'
    else if type == 'object' then 'map'
    else xxx node

  error: (msg)->
    throw msg

module.exports = YamlSchemaCompiler
