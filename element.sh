#!/bin/bash

if [ -z "$1" ]; then
  echo "Please provide an element as an argument."
  exit 0
fi

input="$1"

result=$(psql -U freecodecamp -d periodic_table -t -A -c "
SELECT e.atomic_number, e.name, e.symbol, p.type_id, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
FROM elements e
JOIN properties p ON e.atomic_number = p.atomic_number
WHERE e.atomic_number::text = '$input'
   OR e.symbol = '$input'
   OR LOWER(e.name) = LOWER('$input');
")

if [ -z "$result" ]; then
  echo "I could not find that element in the database."
  exit 0
fi

IFS='|' read -r atomic_number name symbol type_id atomic_mass melting_point boiling_point <<< "$result"

case "$type_id" in
  1) type="metal" ;;
  2) type="nonmetal" ;;
  3) type="metalloid" ;;
  *) type="unknown" ;;
esac

echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
