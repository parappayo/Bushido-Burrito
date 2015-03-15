//
//	Wyvern Tail Project
//  Copyright 2013 Jason Estey
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//

package wyverntail.core
{
	import flash.utils.Dictionary;
	
	public class Factory
	{
		public var prefabs :Dictionary;

		// TODO: can load templates from XML
		
		public function Factory()
		{
			prefabs = new Dictionary();
		}
		
		public function addPrefab(id :String, components :Vector.<Class>, args :Object) :void
		{
			var prefab :Prefab = new Prefab();
			prefab.components = components;
			prefab.args = args;
			prefabs[id] = prefab;
		}
		
		public function spawn(scene :Scene, prefabID :String, spawnArgs :Object = null) :Entity
		{
			var retval :Entity = new Entity(scene);
			scene.add(retval);
			
			if (spawnArgs == null) { spawnArgs = { }; }

			var prefab :Prefab = prefabs[prefabID] as Prefab;
			if (!prefab) { return retval; }
			
			var componentInstances :Vector.<Component> = new Vector.<Component>();

			for each (var componentClass :Class in prefab.components)
			{
				componentInstances.push(retval.attachComponent(componentClass));
			}
			
			// only start the components after they are all attached
			for each (var componentInstance :Component in componentInstances)
			{
				componentInstance.start(prefab.args, spawnArgs);
			}
			
			return retval;
		}

	} // class

} // package

