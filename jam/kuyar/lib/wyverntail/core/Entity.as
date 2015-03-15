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

	public class Entity
	{
		protected var _components :Dictionary;
		
		private static var _entities :Vector.<Entity>;

		public function Entity()
		{
			_components = new Dictionary();

			if (!_entities) { _entities = new Vector.<Entity>(); }
			_entities.push(this);
		}
		
		public function destroy() :void
		{
			for each (var component :Component in _components)
			{
				component.enabled = false;
				component.destroy();
			}
			_components = null;
		}
		
		public static function destroyAll() :void
		{
			for each (var entity :Entity in _entities)
			{
				entity.destroy();
			}
			_entities = new Vector.<Entity>();
		}
		
		public function update(elapsed :Number) :void
		{
			for each (var component :Component in _components)
			{
				component.update(elapsed);
			}
		}
		
		public static function updateAll(elapsed :Number) :void
		{
			for each (var entity :Entity in _entities)
			{
				entity.update(elapsed);
			}
		}
		
		public function handleSignal(signal :int, sender :Object, args :Object) :Boolean
		{
			var retval :Boolean = false;
			for each (var component :Component in _components)
			{
				retval = retval || component.handleSignal(signal, sender, args);
			}
			return retval;
		}
		
		public static function handleSignalAll(signal :int, sender :Object, args :Object) :Boolean
		{
			var retval :Boolean = false;
			for each (var entity :Entity in _entities)
			{
				retval = retval || entity.handleSignal(signal, sender, args);
			}
			return retval;
		}

		public function attachComponent(componentType :Class) :Component
		{
			if (_components.hasOwnProperty(componentType))
			{
				throw new Error("tried to attach a component when one of the same type was already attached");
			}
			
			_components[componentType] = new componentType();
			var component :Component = _components[componentType] as Component;
			
			if (!component)
			{
				throw new Error("tried to attach a component of type that is not a Component");
			}
			
			component.handleAttach(this);
			return component;
		}

		public function getComponent(componentType :Class) :Component
		{
			return _components[componentType] as Component;
		}

		public function removeComponent(componentType :Class) :void
		{
			if (!_components.hasOwnProperty(componentType))
			{
				return;
			}
			
			var component :Component = _components[componentType] as Component;
			component.handleRemove();
			
			_components[componentType] = null;
		}

	} // class

} // package

