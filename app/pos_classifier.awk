BEGIN { FS = " " }

function wilson_lower(pos, neg,    n, p_hat, z2, w) {
    n = pos + neg
    if (n == 0) return 0
    p_hat = pos / n
    z2 = 3.8416
    w = (p_hat + z2/(2*n) - 1.96 * sqrt(p_hat*(1-p_hat)/n + z2/(4*n*n))) / (1 + z2/n)
    if (w < 0) return 0
    return w
}

/^[Uu]nless$/           { conjunction_pos += 8; adjective_neg += 8 }
/^[Nn]evertheless$/     { conjunction_pos += 8; adjective_neg += 8 }
/^[Dd]uring$/           { preposition_pos += 8; verb_neg += 8 }
/^[Uu]ntil$/            { preposition_pos += 8; verb_neg += 8 }
/^[Aa]fter$/            { preposition_pos += 8; noun_neg += 8 }
/^[Uu]nder$/            { preposition_pos += 8; adjective_neg += 8 }
/^[Tt]owards?$/         { preposition_pos += 8; adverb_neg += 8 }
/^[Vv]ery$/             { adverb_pos += 8; noun_neg += 8 }
/^[Ll]ate$/             { adjective_pos += 8; verb_neg += 8 }
/^[Ll]ikewise$/         { adverb_pos += 8; verb_neg += 8 }
/^[Oo]therwise$/        { adverb_pos += 8; verb_neg += 8 }
/^[Cc]lockwise$/        { adverb_pos += 8; verb_neg += 8 }
/^[Hh]owever$/          { conjunction_pos += 8 }
/^[Mm]oreover$/         { conjunction_pos += 8 }
/^[Nn]ever$/            { adverb_pos += 8; noun_neg += 4 }
/^[Tt]hen$/             { adverb_pos += 8; verb_neg += 4 }
/^[Ii]nward[s]?$/       { adverb_pos += 8; adjective_neg += 4 }
/^[Oo]utward[s]?$/      { adverb_pos += 8; verb_neg += 4 }
/^[Oo]ver$/             { preposition_pos += 8; noun_neg += 4 }
/^[Ii]nto$/             { preposition_pos += 8; adjective_neg += 4 }
/^[Ww]ooden$/           { adjective_pos += 8; verb_neg += 8 }
/^[Ll]ittle$/           { adjective_pos += 8; noun_neg += 4 }
/^[Oo]nly$/             { noun_neg += 8 }
/^[Rr]esearch$/         { noun_pos += 8; verb_neg += 4 }
/^[Ww]ell$/             { adverb_pos += 4; interjection_pos += 3 }
/^[Hh]ow$/              { adverb_pos += 4 }

/(tion|sion)$/          { noun_pos += 4 }
/ness$/                 { noun_pos += 4 }
/ment$/                 { noun_pos += 4 }
/(ity|ty)$/             { noun_pos += 4 }
/(ance|ence)$/          { noun_pos += 3 }
/^[A-Z][a-z]/           { noun_pos += 2 }
/ist$/                  { noun_pos += 4 }
/ism$/                  { noun_pos += 4 }
/hood$/                 { noun_pos += 4 }
/ship$/                 { noun_pos += 4 }
/dom$/                  { noun_pos += 4 }
/(ery|ry)$/             { noun_pos += 3 }

/^[a-zA-Z]{5,}er$/      { noun_pos += 3 }
/^[a-zA-Z]{3,}or$/      { noun_pos += 3 }
/^[a-zA-Z]{5,}ar$/      { noun_pos += 2 }

/ly$/                   { noun_neg += 3 }

/./  && prev1_label == "determiner"                                { noun_pos += 4 }
/./  && prev1_label == "adjective"                                 { noun_pos += 3 }
/./  && prev1_label == "adjective" && prev2_label == "determiner"  { noun_pos += 4 }
/./  && prev1_label == "verb"      && prev2_label == "verb"        { noun_pos += 3 }
/^[A-Z][a-z]/  && prev1_label == "verb"                           { noun_pos += 3 }
/./            && prev1_label == "verb" && IS_SENT_END             { noun_pos += 3 }
/./  && prev1_label == "preposition"                               { noun_pos += 3 }
/./  && prev2_label == "determiner" && prev1_label != "noun"        { noun_pos += 3 }

/./  && prev1_label == "pronoun" && prev1_word !~ /^([Mm]y|[Yy]our|[Hh]is|[Ii]ts|[Oo]ur|[Tt]heir)$/ { noun_neg += 3 }

/^[Ii]$/                { pronoun_pos += 4 }
/^[Hh]e$/               { pronoun_pos += 4 }
/^[Ss]he$/              { pronoun_pos += 4 }
/^[Ii]t$/               { pronoun_pos += 4 }
/^[Ww]e$/               { pronoun_pos += 4 }
/^[Tt]hey$/             { pronoun_pos += 4 }
/^[Yy]ou$/              { pronoun_pos += 4 }
/^[Mm]e$/               { pronoun_pos += 4 }
/^[Hh]im$/              { pronoun_pos += 4 }
/^[Hh]er$/              { pronoun_pos += 4 }
/^[Uu]s$/               { pronoun_pos += 4 }
/^[Tt]hem$/             { pronoun_pos += 4 }
/^[Mm]y$/               { pronoun_pos += 4 }
/^[Hh]is$/              { pronoun_pos += 4 }
/^[Ii]ts$/              { pronoun_pos += 4 }
/^[Oo]ur$/              { pronoun_pos += 4 }
/^[Tt]heir$/            { pronoun_pos += 4 }
/^[Yy]our$/             { pronoun_pos += 4 }
/(self|selves)$/        { pronoun_pos += 4 }
/^[Ww]ho$/              { pronoun_pos += 3 }
/^[Ww]hom$/             { pronoun_pos += 3 }
/^[Ww]hose$/            { pronoun_pos += 3 }
/^[Ww]hich$/            { pronoun_pos += 3 }
/^[Tt]hat$/             { pronoun_pos += 3 }

/./  && prev1_label == "determiner"  { pronoun_neg += 3 }

/ing$/                  { verb_pos += 3 }
/ed$/                   { verb_pos += 3 }
/(ize|ise)$/            { verb_pos += 4 }
/(ify|fy)$/             { verb_pos += 4 }
/^[Rr]e[a-zA-Z]{3,}/   && !/ly$/  { verb_pos += 3 }
/^[Dd]e[a-zA-Z]{3,}/   && !/ly$/  { verb_pos += 3 }
/^[Uu]n[a-zA-Z]{3,}/   && !/ly$/  { verb_pos += 3 }
/^[Mm]is[a-zA-Z]{3,}/  && !/ly$/  { verb_pos += 3 }
/^[Oo]ut[a-zA-Z]{3,}/  && !/ly$/  { verb_pos += 3 }

/^[a-zA-Z]{4,}en$/      { verb_pos += 3 }

/^[a-zA-Z]{5,}ate$/     { verb_pos += 3 }

/(tion|ness|ment)$/     { verb_neg += 3 }

/./  && prev1_label == "pronoun" && prev1_word !~ /^([Mm]y|[Yy]our|[Hh]is|[Ii]ts|[Oo]ur|[Tt]heir)$/ { verb_pos += 4 }
/./  && prev1_label == "auxiliary" { verb_pos += 4 }
/ing$/  && prev1_label == "verb"  { verb_pos += 4 }
/ing$/  && prev1_label == "adverb" && prev2_label != "auxiliary" { verb_neg += 2 }

/./  && prev1_label == "determiner" { verb_neg += 6 }
/./  && prev2_label == "determiner" { verb_neg += 4 }

/^[Ii]s$/               { is_aux = 1 }
/^[Ww]as$/              { is_aux = 1 }
/^[Hh]as$/              { is_aux = 1 }
/^[Hh]ave$/             { is_aux = 1 }
/^[Ww]ill$/             { is_aux = 1 }
/^[Cc]an$/              { is_aux = 1 }
/^[Mm]ust$/             { is_aux = 1 }
/^[Ss]hall$/            { is_aux = 1 }
/^[Mm]ay$/              { is_aux = 1 }
/^[Ww]ould$/            { is_aux = 1 }
/^[Cc]ould$/            { is_aux = 1 }
/^[Ss]hould$/           { is_aux = 1 }

/^[Tt]he$/              { determiner_pos += 4; is_det = 1 }
/^[Aa]n?$/              { determiner_pos += 4; is_det = 1 }
/^[Tt]his$/             { determiner_pos += 4; is_det = 1 }
/^[Tt]hese$/            { determiner_pos += 4; is_det = 1 }
/^[Tt]hose$/            { determiner_pos += 4; is_det = 1 }

/ful$/                  { adjective_pos += 4 }
/less$/                 { adjective_pos += 4 }
/(ous|ious)$/           { adjective_pos += 4 }
/(ive|ative)$/          { adjective_pos += 4 }
/(able|ible)$/          { adjective_pos += 4 }
/(al|ial)$/             { adjective_pos += 3 }
/(ic|ical)$/            { adjective_pos += 3 }
/ish$/                  { adjective_pos += 4 }
/some$/                 { adjective_pos += 3 }
/worthy$/               { adjective_pos += 4 }
/^[Uu]n[a-zA-Z]+/      { adjective_pos += 3 }
/^[Ii][nm][a-zA-Z]+/   { adjective_pos += 3 }
/^[Ii][rl][a-zA-Z]+/   { adjective_pos += 3 }
/^[Nn]on-[a-zA-Z]+/    { adjective_pos += 3 }
/^[Aa]nti-[a-zA-Z]+/   { adjective_pos += 3 }
/^[Hh]yper[a-zA-Z]+/   { adjective_pos += 3 }

/^[a-zA-Z]{4,}er$/      { adjective_pos += 2 }
/^[a-zA-Z]{4,}est$/     { adjective_pos += 2 }

/ly$/                   { adjective_neg += 4 }

/./  && prev1_label == "determiner" && next1_label == "noun" { adjective_pos += 3 }
/./  && prev1_label == "adverb"     { adjective_pos += 3 }
/./  && prev1_label == "auxiliary"  { adjective_pos += 5 }
/./  && prev1_word ~ /^([Mm]y|[Yy]our|[Hh]is|[Ii]ts|[Oo]ur|[Tt]heir)$/ && next1_label == "noun" { adjective_pos += 3 }

/./  && prev1_label == "pronoun" && next1_label != "noun"    { adjective_neg += 3 }
/./  && prev1_label == "noun"       { adjective_neg += 2 }

/ly$/                   { adverb_pos += 5 }
/wards?$/               { adverb_pos += 4 }

/wise$/                 { adverb_pos += 5 }

/ways$/                 { adverb_pos += 3 }
/^[Aa]lways$/           { adverb_pos += 4 }
/^[Nn]ever$/            { adverb_pos += 4 }
/^[Oo]ften$/            { adverb_pos += 4 }
/^[Rr]arely$/           { adverb_pos += 4 }
/^[Ss]ometimes$/        { adverb_pos += 4 }
/^[Uu]sually$/          { adverb_pos += 4 }
/^[Nn]ow$/              { adverb_pos += 4 }
/^[Tt]hen$/             { adverb_pos += 4 }
/^[Ss]oon$/             { adverb_pos += 4 }
/^[Tt]oday$/            { adverb_pos += 4 }
/^[Yy]esterday$/        { adverb_pos += 4 }
/^[Aa]lready$/          { adverb_pos += 4 }
/^[Ss]till$/            { adverb_pos += 4 }
/^[Aa]lmost$/           { adverb_pos += 4 }
/^[Nn]early$/           { adverb_pos += 4 }
/^[Jj]ust$/             { adverb_pos += 4 }
/^[Bb]arely$/           { adverb_pos += 4 }
/^[Hh]ardly$/           { adverb_pos += 4 }
/^[Vv]ery$/             { adverb_pos += 3 }
/^[Qq]uite$/            { adverb_pos += 3 }
/^[Rr]ather$/           { adverb_pos += 3 }

/./  && prev1_label == "verb"      { adverb_pos += 3 }
/./  && prev1_label == "adjective" { adverb_pos += 3 }

/./  && prev1_label == "determiner" { adverb_neg += 4 }

/^[Ii]n$/               { preposition_pos += 4 }
/^[Oo]n$/               { preposition_pos += 4 }
/^[Aa]t$/               { preposition_pos += 4 }
/^[Bb]y$/               { preposition_pos += 4 }
/^[Ff]or$/              { preposition_pos += 4 }
/^[Ww]ith$/             { preposition_pos += 4 }
/^[Aa]bout$/            { preposition_pos += 4 }
/^[Oo]ver$/             { preposition_pos += 4 }
/^[Uu]nder$/            { preposition_pos += 4 }
/^[Bb]etween$/          { preposition_pos += 4 }
/^[Ii]nto$/             { preposition_pos += 4 }
/^[Oo]nto$/             { preposition_pos += 4 }
/^[Tt]oward[s]?$/       { preposition_pos += 4 }
/^[Tt]hrough$/          { preposition_pos += 4 }
/^[Aa]cross$/           { preposition_pos += 4 }
/^[Aa]long$/            { preposition_pos += 4 }
/^[Bb]efore$/           { preposition_pos += 3 }
/^[Aa]fter$/            { preposition_pos += 3 }
/^[Dd]uring$/           { preposition_pos += 3 }
/^[Ss]ince$/            { preposition_pos += 3 }
/^[Uu]ntil$/            { preposition_pos += 3 }
/^[Tt]ill$/             { preposition_pos += 3 }
/^[Ww]ithin$/           { preposition_pos += 3 }
/^[Oo]f$/               { preposition_pos += 4 }
/^[Ff]rom$/             { preposition_pos += 4 }
/^[Tt]o$/               { preposition_pos += 4 }
/^[Uu]p$/               { preposition_pos += 4 }
/^[Dd]own$/             { preposition_pos += 4 }
/^[Oo]ff$/              { preposition_pos += 4 }
/^[Pp]ast$/             { preposition_pos += 4 }
/^[Nn]ear$/             { preposition_pos += 4 }
/^[Bb]eside$/           { preposition_pos += 4 }
/^[Bb]ehind$/           { preposition_pos += 4 }
/^[Aa]bove$/            { preposition_pos += 4 }
/^[Bb]elow$/            { preposition_pos += 4 }
/^[Dd]espite$/          { preposition_pos += 4 }
/^[Ee]xcept$/           { preposition_pos += 4 }
/^[Vv]ia$/              { preposition_pos += 4 }

/^[Aa]nd$/              { conjunction_pos += 4 }
/^[Bb]ut$/              { conjunction_pos += 4 }
/^[Oo]r$/               { conjunction_pos += 4 }
/^[Nn]or$/              { conjunction_pos += 4 }
/^[Yy]et$/              { conjunction_pos += 4 }
/^[Ss]o$/               { conjunction_pos += 4 }
/^[Bb]ecause$/          { conjunction_pos += 4 }
/^[Aa]lthough$/         { conjunction_pos += 4 }
/^[Ww]hile$/            { conjunction_pos += 4 }
/^[Ii]f$/               { conjunction_pos += 4 }
/^[Uu]nless$/           { conjunction_pos += 4 }
/^[Ww]hen$/             { conjunction_pos += 4 }
/^[Hh]owever$/          { conjunction_pos += 4 }
/^[Tt]herefore$/        { conjunction_pos += 4 }
/^[Mm]oreover$/         { conjunction_pos += 4 }
/^[Nn]evertheless$/     { conjunction_pos += 4 }
/^[Ff]urthermore$/      { conjunction_pos += 4 }
/^[Tt]hus$/             { conjunction_pos += 4 }
/^[Hh]ence$/            { conjunction_pos += 4 }
/^[Ee]ither$/           { conjunction_pos += 3 }
/^[Nn]either$/          { conjunction_pos += 3 }
/^[Bb]oth$/             { conjunction_pos += 3 }
/^[Ww]hether$/          { conjunction_pos += 3 }

/(tion|ness|ing)$/      { conjunction_neg += 4 }

/^[Oo]h$/               { interjection_pos += 4 }
/^[Ww]ow$/              { interjection_pos += 4 }
/^[Hh]ey$/              { interjection_pos += 4 }
/^[Oo]uch$/             { interjection_pos += 4 }
/^[Aa]h$/               { interjection_pos += 4 }
/^[Uu]gh$/              { interjection_pos += 4 }
/^[Yy]ikes$/            { interjection_pos += 4 }
/^[Hh]urray$/           { interjection_pos += 4 }
/^[Aa]las$/             { interjection_pos += 4 }
/^[Hh]mm$/              { interjection_pos += 4 }
/^[Hh]uh$/              { interjection_pos += 4 }
/^[Uu]m$/               { interjection_pos += 4 }
/^[Uu]h$/               { interjection_pos += 4 }
/^[Gg]osh$/             { interjection_pos += 4 }
/^[Bb]ravo$/            { interjection_pos += 4 }
/^[Hh]ooray$/           { interjection_pos += 4 }
/^[Yy]es$/              { interjection_pos += 3 }
/^[Nn]o$/               { interjection_pos += 3 }
/!$/                    { interjection_pos += 3 }

/(tion|ment|ing|ed)$/   { interjection_neg += 3 }

END {
    if (CURRENT_WORD == "") exit

    if (is_det) {
        print "  {\"word\": \"" CURRENT_WORD "\", \"pos\": \"determiner\", \"certainty\": 1.0000}"
        if (LABEL_FILE != "") print "determiner" > LABEL_FILE
        exit
    }

    if (is_aux) {
        print "  {\"word\": \"" CURRENT_WORD "\", \"pos\": \"auxiliary\", \"certainty\": 1.0000}"
        if (LABEL_FILE != "") print "auxiliary" > LABEL_FILE
        exit
    }

    noun_w         = wilson_lower(noun_pos,         noun_neg)
    pronoun_w      = wilson_lower(pronoun_pos,       pronoun_neg)
    verb_w         = wilson_lower(verb_pos,          verb_neg)
    adjective_w    = wilson_lower(adjective_pos,     adjective_neg)
    adverb_w       = wilson_lower(adverb_pos,        adverb_neg)
    preposition_w  = wilson_lower(preposition_pos,   preposition_neg)
    conjunction_w  = wilson_lower(conjunction_pos,   conjunction_neg)
    interjection_w = wilson_lower(interjection_pos,  interjection_neg)
    determiner_w   = wilson_lower(determiner_pos,    determiner_neg)

    best_score = 0
    best_label = "unknown"

    if (noun_w         > best_score) { best_score = noun_w;         best_label = "noun"         }
    if (pronoun_w      > best_score) { best_score = pronoun_w;      best_label = "pronoun"      }
    if (verb_w         > best_score) { best_score = verb_w;         best_label = "verb"         }
    if (adjective_w    > best_score) { best_score = adjective_w;    best_label = "adjective"    }
    if (adverb_w       > best_score) { best_score = adverb_w;       best_label = "adverb"       }
    if (preposition_w  > best_score) { best_score = preposition_w;  best_label = "preposition"  }
    if (conjunction_w  > best_score) { best_score = conjunction_w;  best_label = "conjunction"  }
    if (interjection_w > best_score) { best_score = interjection_w; best_label = "interjection" }
    if (determiner_w   > best_score) { best_score = determiner_w;   best_label = "determiner"   }

    printf "  {\"word\": \"%s\", \"pos\": \"%s\", \"certainty\": %.4f}\n", \
        CURRENT_WORD, best_label, best_score

    if (LABEL_FILE != "") print best_label > LABEL_FILE
}

/./  && prev1_label == "noun" && preposition_pos == 0 && conjunction_pos == 0 { verb_pos += 4 }

/./  && prev1_label == "adverb" && prev2_label == "pronoun" { verb_pos += 4 }

/./  && next1_label == "preposition" && preposition_pos == 0 && conjunction_pos == 0 && determiner_pos == 0 { verb_pos += 4 }

/./  && next1_label == "adverb" && preposition_pos == 0 && conjunction_pos == 0 && determiner_pos == 0 { verb_pos += 2 }

/./  && next1_label == "pronoun" && pronoun_pos == 0 && preposition_pos == 0 && conjunction_pos == 0 && determiner_pos == 0 { verb_pos += 3 }

/./  && next1_label == "auxiliary" && pronoun_pos == 0 && prev1_word != "to"   { noun_pos += 4 }

/./  && prev1_word ~ /^([Mm]y|[Yy]our|[Hh]is|[Ii]ts|[Oo]ur|[Tt]heir)$/ { noun_pos += 4 }

/./  && prev1_label == "preposition" && prev1_word == "to" { verb_pos += 5 }

/./  && next1_label == "noun" && determiner_pos == 0 && preposition_pos == 0 && pronoun_pos == 0 && conjunction_pos == 0 { adjective_pos += 4 }

/./  && next1_label == "adjective" && preposition_pos == 0 && conjunction_pos == 0 && determiner_pos == 0 { adverb_pos += 2 }
/./  && next1_label == "adjective" && prev1_label == "determiner" { adverb_neg += 4 }

/^[0-9]+(st|nd|rd|th)$/                                                                                              { adjective_pos += 8; noun_neg += 8 }
/^[0-9]+-[a-zA-Z]+$/                                                                                                 { adjective_pos += 6; noun_neg += 4 }
/^[0-9]/ && prev1_word ~ /^([Ii]s|[Ww]as|[Ee]quals?)$/                                                              { noun_pos += 8 }
/^[0-9]/ && prev1_word ~ /^[+\-=\/]$/                                                                                { noun_pos += 8 }
/^[0-9]/ && prev1_word ~ /^[A-Z]/ && prev1_label == "noun" && conjunction_pos == 0 && preposition_pos == 0          { noun_pos += 8 }
/^[0-9]/ && prev1_label == "determiner" && next1_label == "noun"                                                     { adjective_pos += 8 }
/^[0-9]/ && prev1_label == "preposition"                                                                             { noun_pos += 6 }
/^[0-9]/ && next1_label == "noun" && prev1_label != "determiner" && preposition_pos == 0                            { determiner_pos += 6 }
/^[0-9]/ && prev1_label == "" && next1_label == "verb"                                                               { noun_pos += 6 }
/^[0-9]/ && prev1_label == "determiner" && (next1_label == "" || IS_SENT_END)                                        { noun_pos += 6 }
/^[0-9]/ && next1_label == "noun" && prev1_label == "preposition"                                                    { noun_pos += 4 }
/^[0-9]/ && prev1_label == "" && next1_label != "verb" && next1_label != ""                                          { noun_pos += 4 }
