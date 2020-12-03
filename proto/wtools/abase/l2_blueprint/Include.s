( function _Include_s_( ) {

'use strict';

/**
 * Classes defining tool on steroids. Make possible multiple inheritances, removing fields in descendants, defining the schema of structure, typeless objects, generating optimal code for definition, and many cool things alternatives cant do.
  @module Tools/base/Blueprint
*/

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../wtools/Tools.s' );

  require( './l1/Proto.s' );

  require( './l2/Definition.s' );

  require( './l3/BlueprintNamespace.s' );
  require( './l3/Classes.s' );
  require( './l3/Construction.s' );
  require( './l3/Definitions.s' );
  require( './l3/Traits.s' );

  module[ 'exports' ] = wTools;
}

})();
