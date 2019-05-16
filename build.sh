if [[ "$OSTYPE" == "darwin"* ]]; then
  ./ci-build.sh
else
  # On Ubuntu/Lubuntu Linux we need sudo to run docker commands:
  sudo ./ci-build.sh
fi
