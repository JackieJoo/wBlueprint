( function _Blueprint_s_() {

'use strict';

let _global = _global_;
let _ = _global_.wTools;

// --
// implementation
// --

function is( blueprint )
{
  return _.isPrototypeOf( _.Blueprint, blueprint );
}

//

function isBlueprintOf( blueprint, construction )
{
  _.assert( arguments.length === 2 );
  _.assert( _.blueprint.is( blueprint ) );
  return _.construction.isInstanceOf( construction, blueprint );
}

//

function isRuntime( runtime )
{
  if( !runtime )
  return false;
  return Object.getPrototypeOf( runtime ) === _.BlueprintRuntime;
}

//

function blueprintIsBlueprintOf( construction )
{
  let blueprint = this;
  _.assert( arguments.length === 1 );
  _.assert( _.blueprint.is( blueprint ) );
  return _.blueprint.isBlueprintOf( blueprint, construction );
}

//

function compileSourceCode( blueprint )
{
  debugger; /* xxx : ? */
  _.assert( arguments.length === 1 );
  let generator = _.Generator();

  // generator.external( x ); /* zzz : implement */

  generator.import
  ({
    src : _.construction._construct2
  });

  return generator.generateSourceCode();
}

//

function blueprintCompileSourceCode()
{
  let blueprint = this;
  _.assert( arguments.length === 0 );
  return _.blueprint.compileSourceCode( blueprint );
}

//

function define()
{
  let blueprint = Object.create( _.Blueprint );
  blueprint._InternalRoutinesMap = Object.create( null );
  blueprint._NamedDefinitionsMap = Object.create( null );
  blueprint._UnnamedDefinitionsArray = [];
  blueprint.Traits = Object.create( null );
  blueprint.Fields = Object.create( null );
  blueprint.Name = null;

  for( let a = 0 ; a < arguments.length ; a++ )
  {
    _.blueprint._amend
    ({
      blueprint,
      extension : arguments[ a ],
      amending : 'extend',
      blueprintAction : 'inherit',
    });
  }

  let defaultSupplement =
  {
    extendable : _.trait.extendable( false ),
    typed : _.trait.typed( false ),
  }
  _.blueprint._supplement( blueprint, defaultSupplement );

  blueprint.prototype = Object.create( _.Construction.prototype );

  _.blueprint._form( blueprint, 'blueprintForm1' );
  _.blueprint._form( blueprint, 'blueprintForm2' );

  let Name = blueprint.Name || 'Construction';
  let Construction =
  {
    [ Name ] : function()
    {
      return _.construction._make( this, runtime, arguments );
    }
  }
  let construct = Construction[ Name ];

  blueprint.Make = construct;
  blueprint.MakeEach = MakeEach;
  blueprint.From = From;
  blueprint.Retype = Retype;
  blueprint.Make.prototype = blueprint.prototype;
  _.assert( _.routineIs( _.Construction ) );
  _.assert( _.mapIs( _.Construction.prototype ) );

  let runtime = Object.create( _.BlueprintRuntime );
  runtime._InternalRoutinesMap = blueprint._InternalRoutinesMap;
  runtime.Fields = blueprint.Fields;
  runtime.Make = blueprint.Make;
  runtime.MakeEach = blueprint.MakeEach;
  runtime.From = blueprint.From;
  runtime.Retype = blueprint.Retype;
  runtime.prototype = blueprint.prototype;
  runtime.Typed = blueprint.Traits.typed.typed;
  Object.preventExtensions( runtime );

  blueprint.Runtime = runtime;
  construct.Runtime = runtime;

  _.blueprint._form( blueprint, 'blueprintForm3' );

  Object.preventExtensions( blueprint );
  Object.preventExtensions( blueprint._NamedDefinitionsMap );
  Object.preventExtensions( blueprint._UnnamedDefinitionsArray );
  Object.preventExtensions( blueprint.Traits );
  Object.preventExtensions( blueprint.Fields );
  Object.preventExtensions( blueprint._InternalRoutinesMap );

  _.blueprint._validate( blueprint );

  return blueprint;

  /* */

  function Retype()
  {
    return _.construction._retype( this, runtime, arguments );
  }

  /* */

  function From()
  {
    return _.construction._from( this, runtime, arguments );
  }

  /* */

  function MakeEach()
  {
    return _.construction._makeEach( this, runtime, arguments );
  }

  /* */

}

//

function _amend( o )
{

  _.assert( arguments.length === 1 );
  _.routineOptions( _amend, arguments );
  _.assert( _.longHas( [ 'extend', 'supplement' ], o.amending ) );
  _.assert( _.longHas( [ 'throw', 'amend', 'inherit' ], o.blueprintAction ) );

  _amendAct( o.extension );

  return o.blueprint;

  /* */

  function _amendAct( src )
  {
    if( _.longIs( src ) )
    amendWithArray( src );
    else if( _.blueprint.is( src ) )
    amendWithBlueprint1( src );
    else if( _.mapIs( src ) )
    amendWithMap(  src );
    else if( _.definitionIs( src ) )
    amendWithDefinition( src );
    else _.assert( 0, 'Not clear how to amend blueprint' );
  }

  /*

- amendWithArray
- amendWithMap
- amendWithBlueprint1
- amendWithBlueprint2
- amendWithDefinition
- amendWithTrait
- amendWithNamedDefinition
- amendWithUnnamedDefinition
- amendWithPrimitive

  */

  /* */

  function amendWithArray( array )
  {
    for( let e = 0 ; e < array.length ; e++ )
    _amendAct( array[ e ] );
    // _amendAct({ ... o, extension : array[ e ] });
  }

  /* */

  function amendWithMap( map )
  {

    _.assert( _.mapIs( map ) );

    for( let k in map )
    {
      let ext = map[ k ];
      if( _.definitionIs( ext ) )
      {
        amendWithDefinition( ext, k );
      }
      else if( _.arrayIs( ext ) )
      {
        amendWithArray( ext );
      }
      else
      {
        amendWithPrimitive( ext, k );
      }
    }

  }

  /* */

  function amendWithBlueprint1( srcBlueprint )
  {
    if( o.blueprintAction === 'amend' )
    {
      amendWithBlueprint2( srcBlueprint );
      return o.blueprint;
    }
    else if( o.blueprintAction === 'inherit' )
    {
      let extension =
      {
        extension : _.define.extension( o.extension ),
        prototype : _.trait.prototype( o.extension ),
        typed : _.trait.typed( true ),
      };
      _amendAct( extension );
      // _amendAct({ ... o, extension });
    }
    else
    {
      debugger;
      throw _.err( 'Not clear how to extend by blueprint' );
    }
  }

  /* */

  function amendWithBlueprint2( ext, k )
  {
    o.blueprintDepth += 1;
    for( let k in ext.Fields )
    {
      amendWithPrimitive( ext.Fields[ k ], k );
    }
    for( let k in ext._NamedDefinitionsMap )
    {
      let definition = ext._NamedDefinitionsMap[ k ];
      if( definitionDepthCheck( definition ) )
      amendWithNamedDefinition( definition.clone(), k );
    }
    for( let k = 0 ; k < ext._UnnamedDefinitionsArray.length ; k++ )
    {
      let definition = ext._UnnamedDefinitionsArray[ k ];
      if( definitionDepthCheck( definition ) )
      amendWithUnnamedDefinition( definition, k );
    }
    for( let k in ext.Traits )
    {
      let definition = ext.Traits[ k ];
      if( definitionDepthCheck( definition ) )
      amendWithTrait( definition, k );
    }
    o.blueprintDepth -= 1;
  }

  /* */

  function definitionDepthCheck( definition )
  {
    if( !definition.blueprintDepthLimit )
    return true;
    return definition.blueprintDepthLimit + definition.blueprintDepthReserve + o.blueprintDepthReserve > o.blueprintDepth;
  }

  /* */

  function amendWithDefinition( definition, name )
  {
    if( _.traitIs( definition ) )
    amendWithTrait( definition, name );
    else if( definition.definitionGroup === 'definition.named' )
    amendWithNamedDefinition( definition, name );
    else
    amendWithUnnamedDefinition( definition, name );
  }

  /* */

  function amendWithTrait( ext, key )
  {
    _.assert( _.strIs( ext.kind ) );

    if( o.amending === 'supplement' )
    if( o.blueprint.Traits[ ext.kind ] !== undefined )
    return;

    o.blueprint.Traits[ ext.kind ] = ext;

    if( ext.blueprintAmend )
    ext.blueprintAmend( o );
  }

  /* */

  function amendWithNamedDefinition( ext, key )
  {
    _.assert( ext.definitionGroup === 'definition.named' );
    _.assert( _.strIs( key ) );

    if( o.amending === 'supplement' )
    if( o.blueprint._NamedDefinitionsMap[ key ] !== undefined )
    return;

    // _.assert( o.blueprint._NamedDefinitionsMap[ key ] === undefined, 'not tested' ); /* zzz : test */

    o.blueprint._NamedDefinitionsMap[ key ] = ext;
    ext.name = key;

    if( ext.blueprintAmend )
    ext.blueprintAmend( o );
  }

  /* */

  function amendWithUnnamedDefinition( ext )
  {
    _.assert( ext.definitionGroup === 'definition.unnamed' );
    o.blueprint._UnnamedDefinitionsArray.push( ext );
    if( ext.blueprintAmend )
    ext.blueprintAmend( o );
  }

  /* */

  function amendWithPrimitive( ext, key )
  {
    _.assert( _.strIs( key ) );
    _.assert
    (
      _.primitiveIs( ext ) || _.routineIs( ext ),
      () => `Property could be prtimitive or routine, but element ${key} is ${_.strType( key )}.`
      + `\nUse _.defined.* to defined more complex data structure`
    );
    if( o.amending === 'supplement' )
    if( o.blueprint.Fields[ key ] !== undefined )
    return;
    o.blueprint.Fields[ key ] = ext;
  }

  /* */

}

_amend.defaults =
{
  blueprint : null,
  extension : null,
  amending : null,
  blueprintAction : 'throw',
  blueprintDepth : 0,
  blueprintDepthReserve : 0,
}

//

function _supplement( blueprint, extension )
{
  return _.blueprint._amend
  ({
    blueprint,
    extension,
    amending : 'supplement',
  });
}

//

function _extend( blueprint, extension )
{
  return _.blueprint._amend
  ({
    blueprint,
    extension,
    amending : 'extend',
  });
}

//

function _form( blueprint, stage )
{
  _.assert( arguments.length === 2 );
  _.assert( _.blueprint.is( blueprint ) );
  _.assert( _.longHas( [ 'blueprintForm1', 'blueprintForm2', 'blueprintForm3' ], stage ) );

  // let handlersNames = [ 'blueprintForm1', 'blueprintForm2', 'blueprintForm3' ];
  let handlersNames = [ stage ];

  for( let n = 0 ; n < handlersNames.length ; n++ )
  {
    let name = handlersNames[ n ];
    _.blueprint.eachDefinition( blueprint, ( blueprint, definition, key ) =>
    {
      if( definition[ name ] )
      definition[ name ]( blueprint, key );
    });
  }

  return blueprint;
}

//

function _validate( blueprint )
{
  _.assert( _.routineIs( blueprint._InternalRoutinesMap.allocate ), `Each blueprint should have handler::allocate, but definition::${blueprint.name} does not have` );
  _.assert( _.routineIs( blueprint._InternalRoutinesMap.retype ), `Each blueprint should have handler::retype, but definition::${blueprint.name} does not have` );
}

//

function eachDefinition( blueprint, onEach )
{
  _.assert( arguments.length === 2 );
  _.assert( _.blueprint.is( blueprint ) );

  for( let k in blueprint.Traits )
  {
    let trait = blueprint.Traits[ k ];
    onEach( blueprint, trait, k );
  }

  for( let k in blueprint._NamedDefinitionsMap )
  {
    let definition = blueprint._NamedDefinitionsMap[ k ];
    onEach( blueprint, definition, k );
  }

  for( let k = 0 ; k < blueprint._UnnamedDefinitionsArray.length ; k++ )
  {
    let definition = blueprint._UnnamedDefinitionsArray[ k ];
    onEach( blueprint, definition, k );
  }

}

//

function defineConstructor()
{
  let blueprint = _.blueprint.define( ... arguments );
  _.assert( _.routineIs( blueprint.Make ) );
  return blueprint.Make;
}

//

function constructorOf( blueprint )
{
  let result = blueprint.Make;
  _.assert( _.blueprint.is( blueprint ) );
  _.assert( _.routineIs( result ) );
  return result;
}

//

function retyperOf( blueprint )
{
  let result = blueprint.Retype;
  _.assert( _.blueprint.is( blueprint ) );
  _.assert( _.routineIs( result ) );
  return result;
}

//

function construct( blueprint )
{
  _.assert( arguments.length === 1 );

  if( !_.blueprint.is( blueprint ) )
  blueprint = _.blueprint.define( blueprint );

  let construct = _.blueprint.constructorOf( blueprint );
  _.assert( _.routineIs( construct ), 'Cant find constructor for blueprint' );
  let construction = construct();
  return construction;
}

//

function retype( blueprint, construction )
{
  _.assert( arguments.length === 2 );
  _.assert( !!construction );

  if( !_.blueprint.is( blueprint ) )
  blueprint = _.blueprint.define( blueprint );

  let retyper = _.blueprint.retyperOf( blueprint );
  _.assert( _.routineIs( retyper ), 'Cant find retyped for blueprint' );
  let construction2 = retyper( construction );
  _.assert( construction === construction2 );
  return construction;
}

//

function definitionQualifiedName( blueprint, definition )
{

  _.assert( arguments.length === 2 );
  _.assert( _.blueprint.is( blueprint ) );
  _.assert( _.definition.is( definition ) );

  if( _.definition.trait.is( definition ) )
  {
    for( let k in blueprint.Traits )
    {
      if( blueprint.Traits[ k ] === definition )
      return `trait::${k}`
    }
  }
  else
  {
    for( let k in blueprint._NamedDefinitionsMap )
    {
      if( blueprint._NamedDefinitionsMap[ k ] === definition )
      return `definition::${k}`
    }
    for( let k = 0 ; k < blueprint._UnnamedDefinitionsArray.length ; k++ )
    {
      if( blueprint._UnnamedDefinitionsArray[ k ] === definition )
      return `definition::${k}`
    }
  }

  return;
}

// --
// declare
// --

let BlueprintRuntime = Object.create( null );
Object.preventExtensions( BlueprintRuntime );

function Blueprint()
{
  return _.blueprint.define( ... arguments );
}
Blueprint.prototype = null; /* yyy */
Object.setPrototypeOf( Blueprint, null ); /* yyy */
Blueprint.isBlueprintOf = blueprintIsBlueprintOf; /* xxx : move out? */
Blueprint.compileSourceCode = blueprintCompileSourceCode; /* xxx : move out? */
Object.preventExtensions( Blueprint );

_.blueprint = _.blueprint || Object.create( null );

// --
// define blueprint
// --

var BlueprintExtension =
{

  // routines

  is,
  isBlueprintOf,
  isRuntime,
  compileSourceCode,
  define,
  _amend,
  _supplement,
  _extend,
  _form,
  _validate,
  eachDefinition,

  defineConstructor,
  constructorOf,
  retyperOf,
  construct,
  retype,
  definitionQualifiedName,

}

Object.assign( _.blueprint, BlueprintExtension );

// --
// define tools
// --

var ToolsExtension =
{

  // fields

  BlueprintRuntime,
  Blueprint,

}

Object.assign( _, ToolsExtension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();
