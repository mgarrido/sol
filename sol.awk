BEGIN {
    gsub(" ", "|", pat)
}

{
    if (match ($3, pat)) {
	     print $1; $1=$2=$3=$4="";
        sub(/^  */,"", $0);
        print $0;
    }
}
