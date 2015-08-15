package  
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import starling.display.*;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class Play 
	{
		public var actors :Dictionary;
		public var chapters :Dictionary;
		
		private var _portrait :Sprite;
		private var _portraitImage :Image;
		private var _dialogue :TextField;
		
		private var _scene :Scene;
		private var _lineIndex :int;
		
		public function Play() 
		{
			actors = new Dictionary();
			chapters = new Dictionary();
		}

		public function init(data :Class) :void
		{
			var rawData :ByteArray = new data();
			var dataString :String = rawData.readUTFBytes(rawData.length);
			var dataXML :XML = new XML(dataString);
			
			initFromXML(dataXML);
		}

		public function initFromXML(data :XML) :void
		{
			actors = new Dictionary();
			chapters = new Dictionary();
			
			if (data.name().localName != "play")
			{
				throw new Error("unexpected XML format for play data");
			}
			
			for each (var child :XML in data.children())
			{
				addData(child);
			}
		}
		
		private function addData(data :XML) :void
		{
			switch (data.name().localName)
			{
				case "actor":
					var actor :Actor = new Actor();
					actor.initFromXML(data);
					actors[actor.id] = actor;
					break;
					
				case "chapter":
					var chapter :Chapter = new Chapter();
					chapter.initFromXML(data);
					chapters[chapter.id] = chapter;
					break;
			}
		}
		
		public function setActorPortrait(actorId :String, expressionId :String, portraitTexture :Texture) :void
		{
			var actor :Actor = actors[actorId];
			actor.portraits[expressionId] = portraitTexture;
		}
		
		public function run(chapterId :String, sceneId :String, portrait :Sprite, dialogue :TextField) :void
		{
			var chapter :Chapter = chapters[chapterId];
			var scene :Scene = chapter.scenes[sceneId];
			
			runScene(scene, portrait, dialogue);
		}
		
		public function runScene(scene :Scene, portrait :Sprite, dialogue :TextField) :void
		{
			if (_portrait)
			{
				_portrait.removeChild(_portraitImage);
			}
			_portrait = portrait;
			_dialogue = dialogue;
			
			_scene = scene;
			_lineIndex = 0;
			runLine(_scene.lines[0]);
		}
		
		public function runNextLine() :void
		{
			if (_lineIndex < _scene.lines.length - 1)
			{
				_lineIndex++;
				runLine(_scene.lines[_lineIndex]);
			}
		}
		
		public function runLine(line :Line) :void
		{
			var actor :Actor = actors[line.speaker];
			
			if (!actor)
			{
				throw Error("unknown actor found in dialogue: " + line.speaker);
			}
			
			// TODO: support for currentPortraitId
			var portraitTexture :Texture = actor.portraits["default"];
			
			_portrait.removeChild(_portraitImage);
			_portraitImage = new Image(portraitTexture);
			_portrait.addChild(_portraitImage);
			
			_dialogue.text = line.dialogue;
		}
	}

} // package
