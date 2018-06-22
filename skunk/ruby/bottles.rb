#
#  Exercise solution for Sandi Metz's 99 Bottles of OOP book
#    https://www.sandimetz.com/99bottles/
#
#  For the exercise itself,
#    git clone --depth=1 --branch=exercise https://github.com/sandimetz/99bottles.git
#
class Bottles
	def bottles_str(bottle_count)
		if bottle_count < 1
			"no more bottles"
		else
			"#{bottle_count} bottle#{bottle_count > 1 ? 's' : ''}"
		end
	end

	def verse(bottle_count)
		if bottle_count > 0
			<<-VERSE
#{bottles_str(bottle_count)} of beer on the wall, #{bottles_str(bottle_count)} of beer.
Take #{bottle_count > 1 ? 'one' : 'it'} down and pass it around, #{bottles_str(bottle_count-1)} of beer on the wall.
VERSE
		else
			<<-VERSE
No more bottles of beer on the wall, no more bottles of beer.
Go to the store and buy some more, 99 bottles of beer on the wall.
VERSE
		end
	end

	def verses(from_bottle_count, to_bottle_count)
		result = ""
		(from_bottle_count).downto(to_bottle_count).each {|bottle_count|
			result += verse(bottle_count)
			if bottle_count > to_bottle_count
				result += "\n"
			end
		}
		result
	end

	def song()
		verses(99, 0)
	end
end
