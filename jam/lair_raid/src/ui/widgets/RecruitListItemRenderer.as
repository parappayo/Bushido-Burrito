package ui.widgets 
{
	import feathers.controls.renderers.DefaultListItemRenderer;
	import starling.events.*;
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.FeathersControl;
	
	import sim.Character;
	import sim.CharacterClasses;
	
	public class RecruitListItemRenderer extends DefaultListItemRenderer implements IListItemRenderer
	{
		protected var _nameLabel :Label;
		protected var _classLabel :Label;
		protected var _attributesLabel :Label;
 
		public function RecruitListItemRenderer() 
		{
			super();
		}
		
		override protected function initialize() :void
		{
			super.initialize();
			
			labelField = "hack";
			
			if (!_nameLabel)
			{
				_nameLabel = new Label();
				addChild(_nameLabel);
			}
			if (!_classLabel)
			{
				_classLabel = new Label();
				addChild(_classLabel);
			}
			if (!_attributesLabel)
			{
				_attributesLabel = new Label();
				addChild(_attributesLabel);
			}
		}
 
		override protected function draw():void
		{
			super.draw();
			
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const selectionInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
 
			if(dataInvalid)
			{
				// this is handled in super.draw
				//this.commitData();
			}
 
			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;
 
			if(dataInvalid || sizeInvalid)
			{
				this.layout();
			}
		}
 		protected override function commitData() :void
		{
			super.commitData();
			
			if (!_data) { return; }
			
			var chara :Character = _data as Character;
			
			_nameLabel.text = chara.Name;
			_classLabel.text = CharacterClasses.toString(chara.RPGClass) + " (" + chara.Level.toString() + ")";
			_attributesLabel.text = chara.attributesString;
		}
		
		protected function layout() :void
		{
			_nameLabel.width = actualWidth / 8;
			_nameLabel.x = 4;
			
			_classLabel.width = actualWidth / 6;
			_classLabel.x = _nameLabel.x + _nameLabel.width;
			
			_attributesLabel.width = actualWidth * 4 / 5;
			_attributesLabel.x = _classLabel.x + _classLabel.width;
		}
		
	} // class
	
} // package
