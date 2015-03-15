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
		protected var _scene :Scene;
		public function get scene() :Scene { return _scene; }
		
		protected var _components :Dictionary;
		
		public function Entity(scene :Scene)
		{
			_scene = scene;
			_components = new Dictionary();
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
		
		public function update(elapsed :Number) :void
		{
			for each (var component :Component in _components)
			{
				component.update(elapsed);
			}
		}
		
		public function handleSignal(signal :int, sender :Object, args :Object) :Boolean
		{
			var retval :Boolean = false;
			for each (var component :Component in _components)
			{
				if (!component.enabled) { continue; }
				retval = retval || component.handleSignal(signal, sender, args);
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
		
		public function containsComponent(component :Object) :Boolean
		{
			for each (var c :Component in _components)
			{
				if (c == component) { return true; }
			}
			return false;
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

