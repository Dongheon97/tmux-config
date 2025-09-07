#!/usr/bin/env bash
# SK hynix P41 2TB (Ubuntu용 nvme0) 온도 표시: 초록(<50) / 노랑(50–69) / 빨강(>=70)

section="nvme-pci-0c00"  # 우분투용 SSD 섹션명 (필요시 nvme0의 PCI에 맞게 바꿔도 됨)

if command -v sensors >/dev/null 2>&1; then
  temp_raw=$(sensors 2>/dev/null | awk -v sec="$section" '
    $1==sec {inblk=1; next}
    inblk && /Composite:/ {gsub(/\+|°C/,"",$2); print $2; exit}
    inblk && NF==0 {inblk=0}
  ')
  if [ -n "$temp_raw" ]; then
    t=$(printf "%.0f" "$temp_raw" 2>/dev/null)

    # 색상 결정
    if [ "$t" -lt 50 ]; then
      color="colour076"   # green
    elif [ "$t" -lt 70 ]; then
      color="colour220"   # yellow
    else
      color="colour160"   # red
    fi

    # 80°C 이상이면 굵게(선택)
    if [ "$t" -ge 80 ]; then
      printf "SSD:#[bold]#[fg=%s]%d°C#[default]" "$color" "$t"
    else
      printf "SSD:#[fg=%s]%d°C#[default]" "$color" "$t"
    fi
    exit 0
  fi
fi

# sensors가 없거나 섹션명을 못 찾을 때
echo "SSD:N/A"

