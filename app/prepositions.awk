{ w = tolower($0) }

w ~ /^aboard$/       { printf "%-15s preposition\n", $0; next }
w ~ /^about$/        { printf "%-15s preposition\n", $0; next }
w ~ /^above$/        { printf "%-15s preposition\n", $0; next }
w ~ /^across$/       { printf "%-15s preposition\n", $0; next }
w ~ /^against$/      { printf "%-15s preposition\n", $0; next }
w ~ /^along$/        { printf "%-15s preposition\n", $0; next }
w ~ /^alongside$/    { printf "%-15s preposition\n", $0; next }
w ~ /^amid$/         { printf "%-15s preposition\n", $0; next }
w ~ /^amidst$/       { printf "%-15s preposition\n", $0; next }
w ~ /^among$/        { printf "%-15s preposition\n", $0; next }
w ~ /^amongst$/      { printf "%-15s preposition\n", $0; next }
w ~ /^around$/       { printf "%-15s preposition\n", $0; next }
w ~ /^at$/           { printf "%-15s preposition\n", $0; next }
w ~ /^atop$/         { printf "%-15s preposition\n", $0; next }
w ~ /^behind$/       { printf "%-15s preposition\n", $0; next }
w ~ /^below$/        { printf "%-15s preposition\n", $0; next }
w ~ /^beneath$/      { printf "%-15s preposition\n", $0; next }
w ~ /^beside$/       { printf "%-15s preposition\n", $0; next }
w ~ /^besides$/      { printf "%-15s preposition\n", $0; next }
w ~ /^between$/      { printf "%-15s preposition\n", $0; next }
w ~ /^beyond$/       { printf "%-15s preposition\n", $0; next }
w ~ /^by$/           { printf "%-15s preposition\n", $0; next }
w ~ /^circa$/        { printf "%-15s preposition\n", $0; next }
w ~ /^despite$/      { printf "%-15s preposition\n", $0; next }
w ~ /^down$/         { printf "%-15s preposition\n", $0; next }
w ~ /^during$/       { printf "%-15s preposition\n", $0; next }
w ~ /^from$/         { printf "%-15s preposition\n", $0; next }
w ~ /^in$/           { printf "%-15s preposition\n", $0; next }
w ~ /^inside$/       { printf "%-15s preposition\n", $0; next }
w ~ /^into$/         { printf "%-15s preposition\n", $0; next }
w ~ /^near$/         { printf "%-15s preposition\n", $0; next }
w ~ /^notwithstanding$/ { printf "%-15s preposition\n", $0; next }
w ~ /^of$/           { printf "%-15s preposition\n", $0; next }
w ~ /^off$/          { printf "%-15s preposition\n", $0; next }
w ~ /^on$/           { printf "%-15s preposition\n", $0; next }
w ~ /^onto$/         { printf "%-15s preposition\n", $0; next }
w ~ /^outside$/      { printf "%-15s preposition\n", $0; next }
w ~ /^over$/         { printf "%-15s preposition\n", $0; next }
w ~ /^per$/          { printf "%-15s preposition\n", $0; next }
w ~ /^regarding$/    { printf "%-15s preposition\n", $0; next }
w ~ /^through$/      { printf "%-15s preposition\n", $0; next }
w ~ /^throughout$/   { printf "%-15s preposition\n", $0; next }
w ~ /^to$/           { printf "%-15s preposition\n", $0; next }
w ~ /^toward$/       { printf "%-15s preposition\n", $0; next }
w ~ /^towards$/      { printf "%-15s preposition\n", $0; next }
w ~ /^under$/        { printf "%-15s preposition\n", $0; next }
w ~ /^underneath$/   { printf "%-15s preposition\n", $0; next }
w ~ /^until$/        { printf "%-15s preposition\n", $0; next }
w ~ /^upon$/         { printf "%-15s preposition\n", $0; next }
w ~ /^via$/          { printf "%-15s preposition\n", $0; next }
w ~ /^with$/         { printf "%-15s preposition\n", $0; next }
w ~ /^within$/       { printf "%-15s preposition\n", $0; next }
w ~ /^without$/      { printf "%-15s preposition\n", $0; next }

# w ~ /^absent$/      # also adjective ("he was absent")
# w ~ /^after$/       # also conjunction/adverb ("after I left", "the day after")
# w ~ /^anti$/        # also prefix/adjective ("anti-war sentiment")
# w ~ /^as$/          # also conjunction/adverb ("as I said", "twice as fast")
# w ~ /^bar$/         # also noun/verb ("a bar of soap", "bar the door")
# w ~ /^barring$/     # also verb participle ("barring entry")
# w ~ /^before$/      # also conjunction/adverb ("before I go", "I've seen it before")
# w ~ /^but$/         # also conjunction ("I tried but failed")
# w ~ /^concerning$/  # also adjective ("that's concerning")
# w ~ /^considering$/ # also verb ("I'm considering it")
# w ~ /^except$/      # also conjunction/verb ("except me out")
# w ~ /^excepting$/   # also verb participle
# w ~ /^excluding$/   # also verb participle ("excluding taxes")
# w ~ /^following$/   # also verb/adjective ("following the rules", "the following day")
# w ~ /^for$/         # also conjunction ("for he is jolly")
# w ~ /^given$/       # also adjective/verb ("I was given a gift")
# w ~ /^including$/   # also verb participle ("including everyone")
# w ~ /^like$/        # also verb/adjective ("I like it", "like-minded")
# w ~ /^minus$/       # also noun/adjective ("a minus sign", "minus points")
# w ~ /^opposite$/    # also noun/adjective ("the opposite side")
# w ~ /^past$/        # also noun/adjective/verb ("in the past", "past tense")
# w ~ /^pending$/     # also adjective ("pending approval")
# w ~ /^plus$/        # also conjunction/noun/adjective ("a plus sign")
# w ~ /^pro$/         # also noun/adjective ("a pro player")
# w ~ /^re$/          # also noun (musical note)
# w ~ /^round$/       # also noun/verb/adjective/adverb ("a round of drinks")
# w ~ /^sans$/        # also used as adjective in typography
# w ~ /^save$/        # also verb/noun ("save the file")
# w ~ /^since$/       # also conjunction/adverb ("since then", "I have since left")
# w ~ /^than$/        # also conjunction ("better than you")
# w ~ /^till$/        # also noun/verb ("till the land", "cash till")
# w ~ /^unlike$/      # also adjective ("unlike characters")
# w ~ /^up$/          # also adverb/adjective/verb ("prices went up", "up the ante")
# w ~ /^versus$/      # also used as abbreviation "vs"
# w ~ /^worth$/       # also noun/adjective ("net worth", "worth it")

{ }
