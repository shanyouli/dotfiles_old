#!/usr/bin/env bash

use_poetry() {
    PYPROJECT_TOML="${PYPROJECT_TOML:-pyproject.toml}"
    if [[ ! -f "$PYPROJECT_TOML" ]]; then
        log_status "No pyproject.toml found. Executing \`poetry init\` to create a \`$PYPROJECT_TOML\` first."
        poetry init
    fi

    VIRTUAL_ENV=$(poetry env info --path 2>/dev/null ; true)

    if [ -z "$VIRTUAL_ENV" ] || [ ! -d "$VIRTUAL_ENV" ]; then
        log_status "No virtual environment exists. Executing \`poetry install\` to create one."
        poetry install
        VIRTUAL_ENV=$(poetry env info --path)
    fi

    PATH_add "$VIRTUAL_ENV/bin"
    export POETRY_ACTIVE=1
    export VIRTUAL_ENV
}