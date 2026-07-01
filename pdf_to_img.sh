#!/bin/bash

check_dependencies() {
  local missing=()

  if [ "$(command -v pdftoppm)" = "" ]; then
    missing+=("pdftoppm")
  fi

  if [ "$(command -v optipng)" = "" ]; then
    missing+=("optipng")
  fi

  if [ "${#missing[@]}" -gt 0 ]; then
    echo "Missing required dependencies: ${missing[@]}"
    return 1
  fi
}

convert_pdf_to_pngs() {
  local pdf_file="$1"
  local work_dir="$2"

  echo "Converting PDF to PNGs in '$work_dir'..."

  local output
  output=$(
    mkdir -p "$work_dir" &&
      cd "$work_dir" &&
      pdftoppm "../$pdf_file" slide -png 2>&1
  )

  if [ "$?" != "0" ]; then
    echo "$output"
    return 1
  fi

  echo "Done converting PDF."
}

resize_and_optimize() {
  local work_dir="$1"

  echo "Resizing and optimizing images in '$work_dir'..."

  local output
  output=$(
    cd "$work_dir" &&
      mkdir -p Resized &&
      for img in *.png; do
        convert "$img" -resize 2800x "Resized/$img"
      done &&
      cd Resized &&
      optipng *.png 2>&1
  )

  if [ "$?" != "0" ]; then
    echo "$output"
    return 1
  fi

  echo "Done resizing and optimizing."
}

main() {
  check_dependencies || {
    echo "Aborting script: required dependencies are missing."
    exit 1
  }

  local pdf_file="$1"

  if [ "$pdf_file" = "" ]; then
    echo "Please specify a PDF file."
    exit 1
  fi

  local work_dir="$(basename "${pdf_file%.*}")-Slides"

  convert_pdf_to_pngs "$pdf_file" "$work_dir" || {
    echo "Error: Failed to convert PDF to PNGs. Aborting."
    exit 1
  }

  resize_and_optimize "$work_dir" || {
    echo "Error: Failed to resize and optimize images. Aborting."
    exit 1
  }

  echo "PDF has been rendered into images!"
  echo "Navigate to $work_dir/Resized"
}

main "$@"
