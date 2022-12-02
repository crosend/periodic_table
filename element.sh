#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

INPUT=$1

if [[ -z $INPUT ]]
then
  echo -e "Please provide an element as an argument."
else
  # check for number
  if [[ $INPUT =~ ^[0-9]+$ ]] 
  then
    ATOMIC_NUMBER=$INPUT
  fi

  # check for symbol
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol = '$INPUT';")
  # find id 
  if [[ -n $SYMBOL ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$INPUT';")
  fi
  # check for name 
  NAME=$($PSQL "SELECT name FROM elements WHERE name = '$INPUT';")
  # find id
  if [[ -n $NAME ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$INPUT';")
  fi

  if [[ -n $ATOMIC_NUMBER ]]
  then
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUMBER;")
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUMBER;")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER;")
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER;")
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER;")
    TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number = $ATOMIC_NUMBER;")
    TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID;")

    echo $(echo "The element with atomic number $ATOMIC_NUMBER is $NAME $(echo -e "($SYMBOL)" | tr -d '[:space:]'). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius.")

  else
    echo "I could not find that element in the database."
  fi

fi
