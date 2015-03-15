//
//	Wyvern Tail Project
//  Copyright 2013 Jason Estey
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//

package wyverntail.core
{
	public class Scene
	{
		private var _entities :Vector.<Entity>;

		public function Scene()
		{
			_entities = new Vector.<Entity>();
		}
		
		public function add(entity :Entity) :void
		{
			_entities.push(entity);
		}

		public function destroy() :void
		{
			for each (var entity :Entity in _entities)
			{
				entity.destroy();
			}
			_entities = new Vector.<Entity>();
		}
		
		public function update(elapsed :Number) :void
		{
			for each (var entity :Entity in _entities)
			{
				entity.update(elapsed);
			}
		}
		
		public function handleSignal(signal :int, sender :Object, args :Object) :Boolean
		{
			var retval :Boolean = false;
			for each (var entity :Entity in _entities)
			{
				retval = retval || entity.handleSignal(signal, sender, args);
			}
			return retval;
		}
		
		public function findEntities(componentClass :Class) :Vector.<Entity>
		{
			var retval :Vector.<Entity> = new Vector.<Entity>();
			for each (var entity :Entity in _entities)
			{
				if (entity.getComponent(componentClass) != null)
				{
					retval.push(entity);
				}
			}
			return retval;
		}

	} // class

} // package

