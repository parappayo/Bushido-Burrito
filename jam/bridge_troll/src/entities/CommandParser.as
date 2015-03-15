
package entities 
{
	/**
	 *  Interperet player input
	 */
	public class CommandParser 
	{
		private var _game :Game;
		
		private var _verbs :Object =
		{
			"love" : { handler : handleLove },
			"kiss" : { handler : handleLove },
			"hug" : { handler : handleLove },
			"embrace" : { handler : handleLove },
			"respect" : { handler : handleLove },
			
			"assault"	: { handler : handleAttack },
			"attack"	: { handler : handleAttack },
			"hit"		: { handler : handleAttack },
			"hurt"		: { handler : handleAttack },
			"kick"		: { handler : handleAttack },
			"punch"		: { handler : handleAttack },
			"push"		: { handler : handleAttack },
			"kill"		: { handler : handleAttack },
			"destroy"	: { handler : handleAttack },
			"hadouken"	: { handler : handleAttack },
			"rob"		: { handler : handleAttack },
			"steal"		: { handler : handleAttack },
			"extort"	: { handler : handleAttack },
			"trip"		: { handler : handleAttack },
			
			"talk" : { response: "You have a little chat with yourself.", handler : handleTalk },
			"chat" : { response: "You have a little chat with yourself.", handler : handleTalk },
			"greet" : { response: "You greet nobody in particular.", handler : handleTalk },
			
			"hint" : { response : "These games used to make money by selling hint books.\nNow we just search the web." },
			"think" : { response : "After mulling it over, you're not sure you're cut out for this gig." },
			"jump" : { response : "You do a little jump." },
			"dance" : { response : "You dance a little jig." },
			"sing" : { response : "You hum a tune to yourself." },
			"hum" : { response : "You hum a tune to yourself." },
			"whistle" : { response : "You whistle a little melody." },
			"represent" : { response : "You're representing with style." },
			"fart" : { response : "Silent, but deadly." },
			"puke" : { response : "You don't feel nauteous." },
			"vomit" : { response : "You don't feel nauteous." },
			"shoot" : { response : "You don't have a gun to shoot with." },
			"stab" : { response : "You don't have a knife to stab with." },

			"look" : { handler :handleLook },
			"inspect" : { handler :handleLook },
			"examine" : { handler :handleLook },
			"see" : { handler :handleLook },

			"help" : { handler : handleHelp }
		}
		
		private var _heroObject :Object = {
			isHero : true,
			response : {
				"shoot" : "You don't have a gun to shoot with.",
				"stab" : "You don't have a knife to stab with.",

				"riddle" : "He doesn't have time for your riddles.",
				"puzzle" : "He doesn't have time for your riddles.",
				"quiz" : "He doesn't have time for your riddles.",
				"test" : "He doesn't have time for your riddles."
				}
		}
		
		private var _nouns :Object =
		{
			"troll" : { isPlayer : true },
			"monster" : { isPlayer : true },
			"giant" : { isPlayer : true },
			"self" : { isPlayer : true },
			
			"hero" : _heroObject,
			"guy" : _heroObject,
			"man" : _heroObject,
			"dude" : _heroObject,
			"fella" : _heroObject,
			"fellow" : _heroObject,
			"hipster" : _heroObject,
			"person" : _heroObject,
			"pedestrian" : _heroObject,
			"loser" : _heroObject,
			
			"bridge" : {
				description : "A wooden bridge spans a small chasm. Far below, a deep river flows.",
				attackResponse : "The bridge is sturdy and resists your attack.",
				response : { "jump" : "You'd rather not jump to your death." }
			},
				
			"river" : {
				description : "The river does not look safe to swim across, and is far below."
			},
			
			"jig" : {
				response : { "dance" : "You dance a little jig." }
			},
			
			"road" : {},
			"path" : {},
			"grass" : {},
			"dirt" : {},
			"mud" : {},
			"landscape" : {},
			"sky" : {},
			"horizon" : {},
			"trees" : {},
			"scenery" : {}
		}
		
		private var _dirtyWords : Array =
		[
			"fuck", "shit", "piss", "ass", "cunt", "bitch",
			"fucking", "fucker", "shitty", "pissy", "cunty", "bitchy",
			"penis", "vagina", "boner", "pussy", "asshole", "anus"
		]
		
		public function CommandParser(game :Game)
		{
			_game = game;
		}
		
		public function handleInput(input :String) :void
		{
			if (input.length < 2) { return; }
			
			var inputArr :Array = input.split(" ");
			var verbString :String = inputArr[0];
			var nounString :String = "";
			if (inputArr.length > 1)
			{
				nounString = inputArr[inputArr.length - 1];
			}
			
			for each (var word :String in inputArr)
			{
				if (_dirtyWords.indexOf(word) >= 0)
				{
					_game.handleSignal(Signals.SHOW_DIALOG, this, { caption : "How rude!" } );
					return;
				}
			}
			
			var noun :Object = _nouns[nounString];
			
			var verb :Object = _verbs[verbString];
			if (verb)
			{
				if (noun)
				{
					if (noun.response && noun.response[verbString])
					{
						_game.handleSignal(Signals.SHOW_DIALOG, this, { caption : noun.response[verbString] } );
					}
					else if (verb.handler == null)
					{
						_game.handleSignal(Signals.SHOW_DIALOG, this, { caption : "I can't " + verbString + " the " + nounString + "." } );
					}
					else if (!verb.handler(noun, nounString, verbString))
					{
						_game.handleSignal(Signals.SHOW_DIALOG, this, { caption : "I can't " + verbString + " the " + nounString + "." } );
					}
				}
				else if (nounString.length > 0)
				{
					_game.handleSignal(Signals.SHOW_DIALOG, this, { caption : "I don't see any \"" + nounString + "\" here." } );
				}
				else
				{
					if (verb.response)
					{
						_game.handleSignal(Signals.SHOW_DIALOG, this, { caption : verb.response } );
					}
					else
					{
						verb.handler(null, nounString, verbString);
					}
				}
			}
			else if (_nouns[verbString])
			{
				_game.handleSignal(Signals.SHOW_DIALOG, this, { caption : "Do what with the " + verbString + "?" } );
			}
			else
			{
				_game.handleSignal(Signals.SHOW_DIALOG, this, { caption : "I don't know how to \"" + verbString + "\"." } );
			}
		}
		
		private function handleTalk(noun :Object, nounString :String, verbString :String) :Boolean
		{
			if (!noun) { return false; }
			
			if (noun.isHero)
			{
				_game.handleSignal(Signals.SHOW_DIALOG, this, { caption : "He is too busy to talk now." } );
				return true;
			}
			
			return false;
		}
		
		private function handleAttack(noun :Object, nounString :String, verbString :String) :Boolean
		{
			if (!noun)
			{
				_game.handleSignal(Signals.SHOW_DIALOG, this, { caption : "You attack the plain air with reckless abandon." } );
				return true;
			}
			
			if (noun.isPlayer)
			{
				_game.handleSignal(Signals.SHOW_DIALOG, this, { caption : "You resist the urge to inflict self-harm." } );
				return true;
			}
			
			if (noun.isHero)
			{
				if (_game.playerDistanceToHero() > Settings.PunchDistance)
				{
					_game.handleSignal(Signals.SHOW_DIALOG, this, { caption : "You are too far away." } );
				}
				else
				{
					_game.handleSignal(Signals.ATTACK_HERO, this, {});
					_game.handleSignal(Signals.SHOW_DIALOG, this, { caption : "He flees in terror!" } );
				}
				return true;
			}

			if (noun.attackResponse)
			{
				_game.handleSignal(Signals.SHOW_DIALOG, this, { caption : noun.attackResponse } );
				return true;
			}
			
			return false;
		}
		
		private function handleLove(noun :Object, nounString :String, verbString :String) :Boolean
		{
			if (!noun)
			{
				_game.handleSignal(Signals.SHOW_DIALOG, this, { caption : "You practice gestures of affection quietly by yourself." } );
				return true;
			}
			
			if (noun.isPlayer)
			{
				_game.handleSignal(Signals.SHOW_DIALOG, this, { caption : "You pep yourself up with some love and attention." } );
				return true;
			}
			
			if (noun.isHero)
			{
				_game.handleSignal(Signals.VICTORY, this, {} );
				return true;
			}
			
			return false;
		}
		
		private function handleLook(noun :Object, nounString :String, verbString :String) :Boolean
		{
			if (!noun)
			{
				_game.handleSignal(Signals.SHOW_DIALOG, this, { caption : "You look around at nothing in particular." } );
				return true;
			}
			
			if (noun.isPlayer)
			{
				_game.handleSignal(Signals.SHOW_DIALOG, this, { caption : "That's you, an aspiring bridge troll." } );
				return true;
			}
			
			if (noun.isHero)
			{
				_game.handleSignal(Signals.SHOW_DIALOG, this, { caption : "He seems to be a busy fellow." } );
				return true;
			}
			
			if (noun.description)
			{
				_game.handleSignal(Signals.SHOW_DIALOG, this, { caption : noun.description } );
			}
			else
			{
				_game.handleSignal(Signals.SHOW_DIALOG, this, { caption : "I don't see anything interesting there." } );
			}
			return true;
		}
		
		private function handleHelp(noun :Object, nounString :String, verbString :String) :Boolean
		{
			_game.handleSignal(Signals.SHOW_DIALOG, this, { caption : "Use the arrow keys to move.\n\nType commands in the form of \"verb\" \"noun\"." } );
			return true;
		}
		
	} // class

} // package
