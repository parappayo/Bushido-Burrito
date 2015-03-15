//
//	Wyvern Tail Project
//  Copyright 2013 Jason Estey
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//

package wyverntail.core
{
	public class Component
	{
		protected var _entity :Entity;
		public function get scene() :Scene { return _entity.scene; }
		
		public var enabled :Boolean = true;
		
		public function destroy() :void {}
		
		/// called by the Factory after all components are attached
		public function start(prefabArgs :Object, spawnArgs :Object) :void {}
		
		/// called every frame with number of seconds since the last frame
		public function update(elapsed :Number) :void {}
		
		/// signals convey general game events
		public function handleSignal(signal :int, sender :Object, args :Object) :Boolean { return false; }
		
		public function handleAttach(entity :Entity) :void
		{
			_entity = entity;
		}
		
		public function handleRemove() :void
		{
			_entity = null;
		}
		
		public function getComponent(componentClass :Class) :Component
		{
			return _entity ? _entity.getComponent(componentClass) : null;
		}
		
		public function isSibling(other :Component) :Boolean
		{
			if (other == null) { return false; }
			return _entity == other._entity;
		}

	} // class

} // package

