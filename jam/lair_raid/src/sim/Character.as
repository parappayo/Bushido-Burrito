package sim 
{
	import feathers.skins.Scale9ImageStateValueSelector;
	public class Character 
	{
		public var Name :String;
		public var RPGClass :int;
		
		// attributes
		public var BaseMight :int;
		public var BaseVitality :int;
		public var BaseFocus :int;
		public var BaseLore :int;
		public var BaseLeadership :int;
		
		public function get Might() :int		{ return BaseMight + Level * getAttributeMultiplier(CharacterAttributes.MIGHT); }
		public function get Vitality() :int		{ return BaseVitality + Level * getAttributeMultiplier(CharacterAttributes.VITALITY); }
		public function get Focus() :int		{ return BaseFocus + Level * getAttributeMultiplier(CharacterAttributes.FOCUS); }
		public function get Lore() :int			{ return BaseLore + Level * getAttributeMultiplier(CharacterAttributes.LORE); }
		public function get Leadership() :int	{ return BaseLeadership + Level * getAttributeMultiplier(CharacterAttributes.LEADERSHIP); }
		
		public function getAttributeMultiplier(attrib :int) :Number
		{
			if (isPrimaryAttribute(attrib)) { return 3; }
			if (isSecondaryAttribute(attrib)) { return 2.5; }
			return 2;
		}
		
		public function isPrimaryAttribute(attrib :int) :Boolean
		{
			return CharacterClasses.AttributeOrder[RPGClass][0] == attrib;
		}
		
		public function isSecondaryAttribute(attrib :int) :Boolean
		{
			return CharacterClasses.AttributeOrder[RPGClass][1] == attrib;
		}
		
		// progress
		public var XP :int;
		public function get Level() :int
		{
			if (XP > 3000000) {
				return 21 + Math.floor((XP - 3000000) / 1000000);
			}
			if (XP > 2000000) { return 20; }
			if (XP > 1024000) { return 19; }
			if (XP > 512000) { return 18; }
			if (XP > 256000) { return 17; }
			if (XP > 128000) { return 16; }
			if (XP > 64000) { return 15; }
			if (XP > 32000) { return 14; }
			if (XP > 16000) { return 13; }
			if (XP > 8000) { return 12; }
			if (XP > 4000) { return 11; }
			if (XP > 2000) { return 10; }
			if (XP > 1200) { return 9; }
			if (XP > 800) { return 8; }
			if (XP > 500) { return 7; }
			if (XP > 250) { return 6; }
			if (XP > 100) { return 5; }
			if (XP > 50) { return 4; }
			if (XP > 25) { return 3; }
			if (XP > 10) { return 2; }
			return 1;
		}
		
		// combat state
		public var HP :int;
		public function get MaxHP() :int
		{
			return Vitality * 10;
		}
		public var TurnTimer :Number;
		public var DamageMultiplier :Number;
		
		protected var LastTurnDamageDealt :int = 0;
		protected var LastTurnHealingDone :int = 0;
		protected var LastTurnLength :Number = 0;
		public var ThisTurnLength :Number = 0;
		public function getLastTurnDPS() :Number { return LastTurnLength > 0 ? LastTurnDamageDealt / LastTurnLength : 0; }
		public var CombatDamageTotal :int;
		public var CombatHealingTotal :int;
		
		public var WasUsedLastRound :Boolean;
		
		// typical time needed for a single turn in seconds,
		// actual turn time will be anywhere from 1 to (2 * TurnLength) + 1
		static public const TurnLength :Number = 1;
		
		// this helps RecruitListItemRenderer to work
		public const hack :String = "  ";
		
		public function Character() 
		{
			XP = 0;
		}
		
		public function toString() :String
		{
			var retval :String = "";
			retval += Name + " (" + CharacterClasses.toString(RPGClass) + ") ";
			retval += attributesString;
			return retval;
		}
		
		public function get attributesString() :String
		{
			var retval :String = "";
			retval += "Might: " + Might.toString() + " ";
			retval += "Vitality: " + Vitality.toString() + " ";
			retval += "Focus: " + Focus.toString() + " ";
			retval += "Lore: " + Lore.toString() + " ";
			retval += "Leadership: " + Leadership.toString();
			return retval;
		}
		
		public function setBaseAttribute(attrib :int, value :int) :void
		{
			switch (attrib)
			{
				case CharacterAttributes.MIGHT:			BaseMight = value;			break;
				case CharacterAttributes.VITALITY:		BaseVitality = value;		break;
				case CharacterAttributes.FOCUS:			BaseFocus = value;			break;
				case CharacterAttributes.LORE:			BaseLore = value;			break;
				case CharacterAttributes.LEADERSHIP:	BaseLeadership = value;		break;
			}
		}
		
		public function getBaseAttribute(attrib :int) :int
		{
			switch (attrib)
			{
				case CharacterAttributes.MIGHT:			return BaseMight;
				case CharacterAttributes.VITALITY:		return BaseVitality;
				case CharacterAttributes.FOCUS:			return BaseFocus;
				case CharacterAttributes.LORE:			return BaseLore;
				case CharacterAttributes.LEADERSHIP:	return BaseLeadership;
			}
			
			// should never get here
			return Might;
		}
		
		public function roll(name :String, rpgClass :int) :void
		{
			Name = name;
			RPGClass = rpgClass;
			
			var rolls :Array = CharacterAttributes.roll();
			
			var i :int = 0;
			for each (var attrib :int in CharacterClasses.AttributeOrder[RPGClass])
			{
				setBaseAttribute(attrib, rolls[i++]);
			}
		}
		
		public function isDead() :Boolean
		{
			return HP < 1;
		}
		
		public function applyDamage(damage :int) :int
		{
			switch (RPGClass)
			{
				case CharacterClasses.KNIGHT:
					{
						damage *= 1 / 3;
					}
					break;
					
				case CharacterClasses.PALADIN:
					{
						damage *= 2 / 3;
					}
					break;
			}
			
			HP -= damage;
			return damage;
		}
		
		public function applyHealing(healing :int) :int
		{
			healing = Math.max(healing, 0);
			var amount :int = Math.min(healing, MaxHP - HP);
			HP += amount;
			return amount;
		}
		
		public function startCombat() :void
		{
			LastTurnLength = 0;
			ThisTurnLength = rollTurnCooldown();
			LastTurnDamageDealt = 0;
			LastTurnHealingDone = 0;
			WasUsedLastRound = true;
			HP = MaxHP;
			DamageMultiplier = 1;
			CombatDamageTotal = 0;
			CombatHealingTotal = 0;
		}
		
		public function rollTurnCooldown() :Number
		{
			const MaxInitiative :Number = 60;
			var initiative :Number = Focus + Dice.rolld8();
			
			if (Settings.GodMode)
			{
				initiative = MaxInitiative;
			}
			
			initiative = Math.min(initiative, MaxInitiative);
			TurnTimer = ((MaxInitiative - initiative) / MaxInitiative) * 2 * TurnLength + 1;
			
			trace(Name + " rolled a turn length of " + TurnTimer.toFixed(2));
			
			return TurnTimer;
		}
		
		protected function buff(simStage :SimStage) :int
		{
			var healingTotal :int = 0;
			
			// list some vars here to avoid compiler warning about duplicates
			var target :Character;
			
			switch (RPGClass)
			{
				case CharacterClasses.BARD:
					{
						for each (target in simStage.Party)
						{
							healingTotal += target.applyHealing( Leadership / 2 + Dice.rolld8() );
						}
						
						target = simStage.getRandomPartyMember();
						target.DamageMultiplier *= Math.max(Leadership / 8, 1);
					}
					break;
					
				case CharacterClasses.DRUID:
					{
						for each (target in simStage.Party)
						{
							healingTotal += target.applyHealing( Lore + Dice.roll2d8() );
						}
					}
					break;
					
				case CharacterClasses.PALADIN:
					{
						target = simStage.getPartyMemberWithLowestHP();
						if (target) { healingTotal += target.applyHealing( Leadership + Dice.roll2d8() ); }
						
						target = simStage.getPartyMemberWithLowestHP();
						if (target) { healingTotal += target.applyHealing( Leadership + Dice.roll2d8() ); }
						
						target = simStage.getRandomPartyMember();
						target.DamageMultiplier *= Math.max(Leadership / 10, 1);
					}
					break;
					
				case CharacterClasses.RANGER:
					{
						target = simStage.getPartyMemberWithLowestHP();
						if (target) { healingTotal += target.applyHealing( Lore / 5 + Dice.rolld8() ); }
						
						target = simStage.getPartyMemberWithLowestHP();
						if (target) { healingTotal += target.applyHealing( Lore / 5 + Dice.rolld8() ); }
					}
					break;
					
				case CharacterClasses.SAGE:
					{
						target = simStage.getDeadPartyMember();
						if (target)
						{
							healingTotal += target.applyHealing( target.MaxHP );
							target.DamageMultiplier = 1;
							
							// after resurrecting, no more actions
							return healingTotal;
						}
						
						target = simStage.getPartyMemberWithLowestHP();
						if (target) { healingTotal += target.applyHealing( Lore * 3 + Dice.roll2d8() ); }
						
						target = simStage.getPartyMemberWithLowestHP();
						if (target) { healingTotal += target.applyHealing( Leadership * 2 + Dice.roll2d8() ); }
						
						target.DamageMultiplier *= Math.max(Leadership / 15, 1);
					}
					break;
			}
			
			return healingTotal;
		}
		
		protected function attackMobs(mobs :SimStage) :int
		{
			var damageTotal :int = 0;
			
			// list some vars here to avoid compiler warning about duplicates
			var blastRadius :Number;
			var aoeTargets :Vector.<Enemy>;
			var damageRoll :int;
			var aoeTarget :Enemy;
			
			var target :Enemy = mobs.getTarget(this);
			if (!target)
			{
				trace("no targets found");
				return 0;
			}
			
			switch (RPGClass)
			{
				case CharacterClasses.BERZERKER:
					{
						damageTotal += dealDamage(mobs, target, Might * 2 + Dice.roll2d8());
						damageTotal += dealDamage(mobs, target, Might * 2 + Dice.roll2d8());
					}
					break;
					
				case CharacterClasses.KNIGHT:
					{
						damageTotal += dealDamage(mobs, target, (Might * 1.5) + Dice.roll2d8());
					}
					break;

				case CharacterClasses.NINJA:
					{
						if (target) { damageTotal += dealDamage(mobs, target, (Might * 0.8) + Dice.roll2d8()); }
						target = mobs.getTarget(this);
						if (target) { damageTotal += dealDamage(mobs, target, (Might * 0.8) + Dice.roll2d8()); }
						target = mobs.getTarget(this);
						if (target) { damageTotal += dealDamage(mobs, target, (Might * 0.8) + Dice.roll2d8()); }
					}
					break;
					
				case CharacterClasses.RANGER:
					{
						if (target) { damageTotal += dealDamage(mobs, target, (Might) + Dice.roll2d8()); }
						target = mobs.getTarget(this);
						if (target) { damageTotal += dealDamage(mobs, target, (Might) + Dice.roll2d8()); }
					}
					break;
					
				case CharacterClasses.WARLOCK:
					{
						blastRadius = Settings.ScreenHeight / 10;
						
						aoeTargets = mobs.getAreaTargets(
							target.PositionX, target.PositionY,
							blastRadius);
							
						if (aoeTargets.length < 1)
						{
							trace("no AOE targets found");
						}
							
						damageRoll = Lore + Dice.rolld8();
							
						for each (aoeTarget in aoeTargets)
						{
							damageTotal += dealDamage(mobs, aoeTarget, damageRoll);
						}
					}
					break;
					
				case CharacterClasses.WIZARD:
					{
						blastRadius = Settings.ScreenHeight / 6;
						
						aoeTargets = mobs.getAreaTargets(
							target.PositionX, target.PositionY,
							blastRadius);
							
						if (aoeTargets.length < 1)
						{
							trace("no AOE targets found");
						}
							
						damageRoll = (Lore / 3) + Dice.rolld8();
							
						for each (aoeTarget in aoeTargets)
						{
							damageTotal += dealDamage(mobs, aoeTarget, damageRoll);
						}
					}
					break;
					
				default:
					{
						// standard melee
						damageTotal += dealDamage(mobs, target, Might + Dice.rolld8());
					}
					break;
			}
			
			return damageTotal;
		}
		
		protected function dealDamage(simStage :SimStage, target :Enemy, damage :int) :int
		{
			damage *= DamageMultiplier;
			
			target.applyDamage(damage);
			
			trace(Name + " dealt " + damage.toFixed(0) + " damage to " + target.Name);
			if (target.isDead())
			{
				XP += target.RewardXP;
				
				var tagAlongXP :int = Math.floor(target.RewardXP / 20);
				for each (var chara :Character in simStage.Party)
				{
					chara.XP += tagAlongXP;
				}
				
				trace(target.Name + " is defeated");
			}
			
			return damage;
		}
		
		public function update(game :Game, elapsed :Number) :void
		{
			if (isDead()) { TurnTimer = ThisTurnLength; return; }
			TurnTimer -= elapsed;
		}
		
		public function fightStage(simStage :SimStage) :void
		{
			if (TurnTimer > 0) { return; }
			LastTurnLength = ThisTurnLength;
			ThisTurnLength = rollTurnCooldown();
			
			LastTurnHealingDone = buff(simStage);
			LastTurnDamageDealt = attackMobs(simStage);
			
			CombatHealingTotal += LastTurnHealingDone;
			CombatDamageTotal += LastTurnDamageDealt;
			
			trace("damage total = " + LastTurnDamageDealt.toString());
			trace("healing total = " + LastTurnHealingDone.toString());
		}
		
	} // class

} // package
