#!/usr/bin/env bash
# GPU 메모리 사용량만 출력 (형광초록)
if command -v nvidia-smi >/dev/null 2>&1; then
  mem=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits | head -n1)
  # tmux 색상 코드로 출력
  printf "#GPU:#[fg=colour076]%dMiB#[default]" "$mem"
else
  echo "#[fg=colour46]GPU:N/A#[default]"
fi

