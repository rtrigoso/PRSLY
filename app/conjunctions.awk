{ w = tolower($0) }

w ~ /^and$/          { printf "%-10s conjunction\n", $0; next }
w ~ /^but$/          { printf "%-10s conjunction\n", $0; next }
w ~ /^or$/           { printf "%-10s conjunction\n", $0; next }
w ~ /^nor$/          { printf "%-10s conjunction\n", $0; next }
w ~ /^for$/          { printf "%-10s conjunction\n", $0; next }
w ~ /^yet$/          { printf "%-10s conjunction\n", $0; next }
w ~ /^so$/           { printf "%-10s conjunction\n", $0; next }
w ~ /^although$/     { printf "%-10s conjunction\n", $0; next }
w ~ /^because$/      { printf "%-10s conjunction\n", $0; next }
w ~ /^since$/        { printf "%-10s conjunction\n", $0; next }
w ~ /^unless$/       { printf "%-10s conjunction\n", $0; next }
w ~ /^until$/        { printf "%-10s conjunction\n", $0; next }
w ~ /^while$/        { printf "%-10s conjunction\n", $0; next }
w ~ /^after$/        { printf "%-10s conjunction\n", $0; next }
w ~ /^before$/       { printf "%-10s conjunction\n", $0; next }
w ~ /^if$/           { printf "%-10s conjunction\n", $0; next }
w ~ /^though$/       { printf "%-10s conjunction\n", $0; next }
w ~ /^whether$/      { printf "%-10s conjunction\n", $0; next }
w ~ /^as$/           { printf "%-10s conjunction\n", $0; next }
w ~ /^once$/         { printf "%-10s conjunction\n", $0; next }
w ~ /^when$/         { printf "%-10s conjunction\n", $0; next }
w ~ /^where$/        { printf "%-10s conjunction\n", $0; next }
w ~ /^than$/         { printf "%-10s conjunction\n", $0; next }
w ~ /^both$/         { printf "%-10s conjunction\n", $0; next }
w ~ /^either$/       { printf "%-10s conjunction\n", $0; next }
w ~ /^neither$/      { printf "%-10s conjunction\n", $0; next }
w ~ /^not$/          { printf "%-10s conjunction\n", $0; next }
w ~ /^lest$/         { printf "%-10s conjunction\n", $0; next }

{ }
