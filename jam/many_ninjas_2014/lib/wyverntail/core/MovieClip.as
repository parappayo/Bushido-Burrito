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
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;

	public class MovieClip extends Component
	{
		private var _parent :starling.display.Sprite;
		protected var _pos :Position2D;
		private var _animationClips :Dictionary;
		
		// details on the currently playing animation
		private var _clip :starling.display.MovieClip;
		private var _animationName :String;
		private var _loop :Boolean;
		private var _isDone :Boolean;
		
		private var _pivotOffsetX :Number;
		private var _pivotOffsetY :Number;
		
		public function get width() :Number
		{
			if (_clip) { return _clip.width; }
			return 0;
		}
		public function get height() :Number
		{
			if (_clip) { return _clip.height; }
			return 0;
		}
		public function get pivotX() :Number
		{
			if (_clip) { return _clip.pivotX; }
			return 0;
		}
		public function get pivotY() :Number
		{
			if (_clip) { return _clip.pivotY; }
			return 0;
		}
		
		private var _scaleX :Number;
		private var _scaleY :Number;
		public function set scaleX(value :Number) :void
		{
			_scaleX = value;
			if (_clip) { _clip.scaleX = value; }
		}
		public function set scaleY(value :Number) :void
		{
			_scaleY = value;
			if (_clip) { _clip.scaleY = value; }
		}
		public function get scaleX() :Number { return _scaleX; }
		public function get scaleY() :Number { return _scaleY; }
		
		public function MovieClip()
		{
			_animationClips = new Dictionary();
			_isDone = true;
			scaleX = 1;
			scaleY = 1;
		}
		
		override public function destroy() :void
		{
			_parent = null;
			if (_clip != null)
			{
				_clip.removeFromParent(true);
				_clip = null;
			}
			_animationClips = null;
			_pos = null;
		}
		
		override public function start(prefabArgs :Object, spawnArgs :Object) :void
		{
			_pos = getComponent(Position2D) as Position2D;
			
			setParent(prefabArgs.parentSprite);
			
			_pivotOffsetX = prefabArgs.pivotOffsetX == null ? 0 : prefabArgs.pivotOffsetX;
			_pivotOffsetY = prefabArgs.pivotOffsetY == null ? 0 : prefabArgs.pivotOffsetY;
		}
		
		override public function update(elapsed :Number) :void
		{
			if (_clip == null) { return; }

			_clip.visible = enabled;
			if (!enabled) { return; }
			
			refreshPosition();
		}
		
		public function refreshPosition() :void
		{
			if (!_clip || !_pos) { return; }
			
			_clip.x = _pos.worldX;
			_clip.y = _pos.worldY;
		}
		
		public function setParent(parentSprite :starling.display.Sprite) :void
		{
			if (!_isDone && _parent)
			{
				throw new Error("tried to change MovieClip's parent while animation was playing");
				return;
			}
			
			_parent = parentSprite;
		}
		
		public function addChild(sprite :DisplayObject) :void
		{
			_parent.addChild(sprite);
		}

		public function addAnimation(name :String, textures :Vector.<Texture>, framerate :int) :void
		{
			var clip :starling.display.MovieClip = new starling.display.MovieClip(textures, framerate);
			
			//clip.pivotX = clip.width * 0.5 + _pivotOffsetX;
			//clip.pivotY = clip.height * 0.5 + _pivotOffsetY;
			clip.pivotX = Settings.TileWidth * 0.5 + _pivotOffsetX;
			clip.pivotY = Settings.TileHeight * 0.5 + _pivotOffsetY;
			
			_animationClips[name] = clip;
		}
		
		public function play(name :String, loop :Boolean = false) :void
		{
			var clip :starling.display.MovieClip = _animationClips[name];
			if (clip == _clip && !_isDone) { return; } // allow spamming calls

			stop();

			if (!clip)
			{
				throw new Error("unknown animation name given");
				return;
			}
			if (!_parent)
			{
				throw new Error("cannot play animation when parent not set");
				return;
			}
			
			_loop = loop;
			_animationName = name;
			_isDone = false;
			
			_clip = clip;
			_clip.scaleX = scaleX;
			_clip.scaleY = scaleY;
			
			_clip.addEventListener(Event.COMPLETE, handleComplete);
			_parent.addChild(_clip);
			Starling.juggler.add(_clip);
			_clip.play();
			
			refreshPosition();
		}
		
		public function stop() :void
		{
			if (_clip == null) { return; }
			
			Starling.juggler.remove(_clip);
			_clip.removeFromParent();
			_clip.removeEventListener(Event.COMPLETE, handleComplete);
			
			_clip = null;
			_animationName = "";
			_loop = false;
			_isDone = true;
		}
		
		public function handleComplete():void
		{
			if (!_loop)
			{
				_clip.pause();
				_isDone = true;
			}
		}
		
		public function get isDone() :Boolean { return _isDone; }
		
	} // class

} // package
