#!/bin/bash
DEBUG=1

#xxd -p | 

for line in $(sed 's/0b01010e/\n0b01010e/g' | sed \
-e 's/0102/\n0102/g' \
-e 's/4101/\n4101/g' \
-e 's/1902/\n1902/g' \
-e 's/1804/\n1804/g' \
-e 's/1704/\n1704/g' \
-e 's/1602/\n1602/g' \
-e 's/1504/\n1504/g' \
-e 's/1404/\n1404/g' \
-e 's/1304/\n1304/g' \
-e 's/1204/\n1204/g' \
-e 's/1102/\n1102/g' \
-e 's/1002/\n1002/g' \
-e 's/0f02/\n0f02/g' \
-e 's/0e04/\n0e04/g' \
-e 's/0d04/\n0d04/g' \
-e 's/0702/\n0702/g' \
-e 's/0602/\n0602/g' \
-e 's/0502/\n0502/g' \
-e 's/0208/\n0208/g')
do

  KLV=$(echo $line | grep '^0102\|^4101\|^1902\|^1804\|^1704\|^1602\|^1504\|^1404\|^1304\|^1204\|^1102\|^1002\|^0f02\|^0e04\|^0d04\|^0702\|^0602\|^0502\|^0208' )
  if [ ! -z "$KLV" ]; then

    TAG_ID=${KLV:0:4}
    LENGTH=$((2*$(printf "%d" "0x${TAG_ID:2:2}")))
    PAYLOAD=${KLV:4:$(($LENGTH))}
    case $TAG_ID in
      0102)
        if [ $DEBUG == 1 ]; then echo "TAG: $TAG_ID LENGTH: $LENGTH PAYLOAD: $PAYLOAD"; fi
        echo "              Checksum: $PAYLOAD"
      ;;
      4101)
        if [ $DEBUG == 1 ]; then echo "TAG: $TAG_ID LENGTH: $LENGTH PAYLOAD: $PAYLOAD"; fi
        echo "       UAS LDS Version: ${PAYLOAD}"
      ;;
      1902)
        if [ $DEBUG == 1 ]; then echo "TAG: $TAG_ID LENGTH: $LENGTH PAYLOAD: $PAYLOAD"; fi
        echo "Frame Center Elevation:" $(awk "BEGIN { printf \"%.8f\", ((19900/65535) * $((0x${PAYLOAD})) - 900 ) * (3.2808399/1) }")
      ;;
      1804)
        if [ $DEBUG == 1 ]; then echo "TAG: $TAG_ID LENGTH: $LENGTH PAYLOAD: $PAYLOAD"; fi
      ;;
      1704)
        if [ $DEBUG == 1 ]; then echo "TAG: $TAG_ID LENGTH: $LENGTH PAYLOAD: $PAYLOAD"; fi
        echo " Frame Center Latitude:" $(awk "BEGIN { printf \"%.8f\", (180/4294967294) * $((0x${PAYLOAD})) }")
      ;;
      1602)
        if [ $DEBUG == 1 ]; then echo "TAG: $TAG_ID LENGTH: $LENGTH PAYLOAD: $PAYLOAD"; fi
      ;;
      1504)
        if [ $DEBUG == 1 ]; then echo "TAG: $TAG_ID LENGTH: $LENGTH PAYLOAD: $PAYLOAD"; fi
      ;;
      1404)
        if [ $DEBUG == 1 ]; then echo "TAG: $TAG_ID LENGTH: $LENGTH PAYLOAD: $PAYLOAD"; fi
      ;;
      1304)
        if [ $DEBUG == 1 ]; then echo "TAG: $TAG_ID LENGTH: $LENGTH PAYLOAD: $PAYLOAD"; fi
#        echo "Sensor Rel. Elevation Angle: ${PAYLOAD}"
      ;;
      1204)
        if [ $DEBUG == 1 ]; then echo "TAG: $TAG_ID LENGTH: $LENGTH PAYLOAD: $PAYLOAD"; fi
        echo "Sensor Rel. Azimuth Angle:" $(awk "BEGIN { printf \"%.8f\", (360/4294967294) * $((0x${PAYLOAD})) }")
      ;;
      1102)
        if [ $DEBUG == 1 ]; then echo "TAG: $((0x$TAG_ID)) LENGTH: $LENGTH PAYLOAD: $PAYLOAD"; fi
        echo "      Sensor Vertical FOV:" $(awk "BEGIN { printf \"%.8f\", (180/65535) * $((0x${PAYLOAD})) }")
      ;;
      1002)
        if [ $DEBUG == 1 ]; then echo "TAG: $TAG_ID LENGTH: $LENGTH PAYLOAD: $PAYLOAD"; fi
        echo "    Sensor Horizontal FOV:" $(awk "BEGIN { printf \"%.8f\", (180/65535) * $((0x${PAYLOAD})) }")
      ;;
      0f02)
        if [ $DEBUG == 1 ]; then echo "TAG: $TAG_ID LENGTH: $LENGTH PAYLOAD: $PAYLOAD"; fi
        echo "  Sensor True Altitude:" $(awk "BEGIN { printf \"%.2f\", (19900/65535) * $((0x${PAYLOAD})) - 900 }")
      ;;
      0e04)
        if [ $DEBUG == 1 ]; then echo "TAG: $TAG_ID LENGTH: $LENGTH PAYLOAD: $PAYLOAD"; fi
        echo "      Sensor Longitude:" $(awk "BEGIN { printf \"%.8f\", (360/4294967294) * $((0x${PAYLOAD})) }")
      ;;
      0d04)
        if [ $DEBUG == 1 ]; then echo "TAG: $TAG_ID LENGTH: $LENGTH PAYLOAD: $PAYLOAD"; fi
        echo "       Sensor Latitude:" $(awk "BEGIN { printf \"%.8f\", (180/4294967294) * $((0x${PAYLOAD})) }")
      ;;
      0702)
        if [ $DEBUG == 1 ]; then echo "TAG: $TAG_ID LENGTH: $LENGTH PAYLOAD: $PAYLOAD"; fi
        echo "   Platform Roll Angle:" $(awk "BEGIN { printf \"%.8f\", (100/65534) * $((0x${PAYLOAD})) }")
      ;;
      0602)
        if [ $DEBUG == 1 ]; then echo "TAG: $TAG_ID LENGTH: $LENGTH PAYLOAD: $PAYLOAD"; fi
        echo "  Platform Pitch Angle:" $(awk "BEGIN { printf \"%.8f\", (40/65534) * $((0x${PAYLOAD})) }")
      ;;
      0502)
        if [ $DEBUG == 1 ]; then echo "TAG: $TAG_ID LENGTH: $LENGTH PAYLOAD: $PAYLOAD"; fi
        echo "Platform Heading Angle:" $(awk "BEGIN { printf \"%.8f\", (360/65535) * $((0x${PAYLOAD})) }")
      ;;
      0208)
        if [ $DEBUG == 1 ]; then echo "TAG: $TAG_ID LENGTH: $LENGTH PAYLOAD: $PAYLOAD"; fi
        echo "             Timestamp: $(date -ud @$((0x${PAYLOAD})))"
      ;;
    esac
  fi
done
