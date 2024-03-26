#!/bin/sh
###############################################################
## Spreadsheet test script                                   ##
###############################################################

HOST=localhost:3000

SCORE=0

###############################################################
## Test [1]: list                                            ##
###############################################################
RESOURCE=$HOST/cells
ANSWER="\[\]"

STATUS=$(curl -s -X GET -o body -w "%{http_code}" $RESOURCE)
if [ $STATUS == "200" ]; then
    grep -q $ANSWER body
    if [ $? -eq 0 ]; then
        echo "Test [1]: OK"; SCORE=$(expr $SCORE + 1)
    else
        echo "Test [1]: FAIL"
    fi
else
    echo "Test [1]: FAIL (" $STATUS "!= 200 )"
fi

###############################################################
## Test [2]: update                                          ##
###############################################################
ID="B2"; FORMULA="6"
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X PUT -d "{\"id\":\"$ID\",\"formula\":\"$FORMULA\"}" \
    -H "Content-Type: application/json" -w "%{http_code}" $RESOURCE)
if [ $STATUS == "201" ]; then
    echo "Test [2]: OK"; SCORE=$(expr $SCORE + 1)
else
    echo "Test [2]: FAIL (" $STATUS "!= 201 )"
fi

###############################################################
## Test [3]: update                                          ##
###############################################################
ID="B3"; FORMULA="3 + 4"
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X PUT -d "{\"id\":\"$ID\",\"formula\":\"$FORMULA\"}" \
    -H "Content-Type: application/json" -w "%{http_code}" $RESOURCE)
if [ $STATUS == "201" ]; then
    echo "Test [3]: OK"; SCORE=$(expr $SCORE + 1)
else
    echo "Test [3]: FAIL (" $STATUS "!= 201 )"
fi

###############################################################
## Test [4]: update                                          ##
###############################################################
ID="D4"; FORMULA="3000"
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X PUT -d "{\"id\":\"$ID\",\"formula\":\"$FORMULA\"}" \
    -H "Content-Type: application/json" -w "%{http_code}" $RESOURCE)
if [ $STATUS == "201" ]; then
    echo "Test [4]: OK"; SCORE=$(expr $SCORE + 1)
else
    echo "Test [4]: FAIL (" $STATUS "!= 201 )"
fi

###############################################################
## Test [5]: update                                          ##
###############################################################
ID="D4"; FORMULA="B2 * B3"
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X PUT -d "{\"id\":\"$ID\",\"formula\":\"$FORMULA\"}" \
    -H "Content-Type: application/json" -w "%{http_code}" $RESOURCE)
if [ $STATUS == "204" ]; then
    echo "Test [5]: OK"; SCORE=$(expr $SCORE + 1)
else
    echo "Test [5]: FAIL (" $STATUS "!= 204 )"
fi

###############################################################
## Test [6]: read                                            ##
###############################################################
ID="D4"
ANSWER="\"formula\":\"42\""
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X GET -o body -w "%{http_code}" $RESOURCE)
if [ $STATUS == "200" ]; then
    grep -q $ANSWER body
    if [ $? -eq 0 ]; then
        echo "Test [6]: OK"; SCORE=$(expr $SCORE + 1)
    else
        echo "Test [6]: FAIL"
    fi
else
    echo "Test [6]: FAIL (" $STATUS "!= 200 )"
fi

###############################################################
## Test [7]: update                                          ##
###############################################################
ID="A9"
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X PUT -d "{\"id\":\"$ID\"}" \
    -H "Content-Type: application/json" -w "%{http_code}" $RESOURCE)
if [ $STATUS == "400" ]; then
    echo "Test [7]: OK"; SCORE=$(expr $SCORE + 1)
else
    echo "Test [7]: FAIL (" $STATUS "!= 400 )"
fi

###############################################################
## Test [8]: update                                          ##
###############################################################
ID="A9"
FORMULA="3000 + 7000"
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X PUT -d "{\"formula\":\"$FORMULA\"}" \
    -o body -H "Content-Type: application/json" -w "%{http_code}" $RESOURCE)
if [ $STATUS == "400" ]; then
    echo "Test [8]: OK"; SCORE=$(expr $SCORE + 1)
else
    echo "Test [8]: FAIL (" $STATUS "!= 400 )"
fi

###############################################################
## Test [9]: update                                          ##
###############################################################
ID="B2"; ID2="B3"; FORMULA="3 + 4"
RESOURCE=$HOST/cells/$ID2

STATUS=$(curl -s -X PUT -d "{\"id\":\"$ID\",\"formula\":\"$FORMULA\"}" \
    -H "Content-Type: application/json" -w "%{http_code}" $RESOURCE)
if [ $STATUS == "400" ]; then
    echo "Test [9]: OK"; SCORE=$(expr $SCORE + 1)
else
    echo "Test [9]: FAIL (" $STATUS "!= 400 )"
fi

###############################################################
## Test [10]: list                                           ##
###############################################################
RESOURCE=$HOST/cells
ANSWER1="B2"
ANSWER2="B3"
ANSWER3="D4"

STATUS=$(curl -s -X GET -o body -w "%{http_code}" $RESOURCE)
if [ $STATUS == "200" ]; then
    grep -q $ANSWER1 body
    if [ $? -eq 0 ]; then
        grep -q $ANSWER2 body
        if [ $? -eq 0 ]; then
            grep -q $ANSWER3 body
            if [ $? -eq 0 ]; then
                echo "Test [10]: OK"; SCORE=$(expr $SCORE + 1)
            else
                echo "Test [10]: FAIL"
            fi
        else
            echo "Test [10]: FAIL"
        fi
    else
        echo "Test [10]: FAIL"
    fi
else
    echo "Test [10]: FAIL (" $STATUS "!= 200 )"
fi

###############################################################
## Test [11]: update                                         ##
###############################################################
ID="B2"; FORMULA="100 + 400 / 5"
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X PUT -d "{\"id\":\"$ID\",\"formula\":\"$FORMULA\"}" \
    -H "Content-Type: application/json" -w "%{http_code}" $RESOURCE)
if [ $STATUS == "204" ]; then
    echo "Test [11]: OK"; SCORE=$(expr $SCORE + 1)
else
    echo "Test [11]: FAIL (" $STATUS "!= 204 )"
fi

###############################################################
## Test [12]: update                                         ##
###############################################################
ID="B3"; FORMULA="10 + (30 / 2)"
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X PUT -d "{\"id\":\"$ID\",\"formula\":\"$FORMULA\"}" \
    -H "Content-Type: application/json" -w "%{http_code}" $RESOURCE)
if [ $STATUS == "204" ]; then
    echo "Test [12]: OK"; SCORE=$(expr $SCORE + 1)
else
    echo "Test [12]: FAIL (" $STATUS "!= 204 )"
fi

###############################################################
## Test [13]: update                             	     ##
###############################################################
ID="D4"; FORMULA="B2 - B3"
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X PUT -d "{\"id\":\"$ID\",\"formula\":\"$FORMULA\"}" \
    -H "Content-Type: application/json" -w "%{http_code}" $RESOURCE)
if [ $STATUS == "204" ]; then
    echo "Test [13]: OK"; SCORE=$(expr $SCORE + 1)
else
    echo "Test [13]: FAIL (" $STATUS "!= 204 )"
fi

###############################################################
## Test [14]: read                                           ##
###############################################################
ID="D4"
ANSWER="\"formula\":\"155.0\""
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X GET -o body -w "%{http_code}" $RESOURCE)
if [ $STATUS == "200" ]; then
    grep -q $ANSWER body
    if [ $? -eq 0 ]; then
        echo "Test [14]: OK"; SCORE=$(expr $SCORE + 1)
    else
        echo "Test [14]: FAIL"
    fi
else
    echo "Test [14]: FAIL (" $STATUS "!= 200 )"
fi

###############################################################
## Test [15]: list                                           ##
###############################################################
RESOURCE=$HOST/cells
ANSWER1="B2"
ANSWER2="B3"
ANSWER3="D4"

STATUS=$(curl -s -X GET -o body -w "%{http_code}" $RESOURCE)
if [ $STATUS == "200" ]; then
    grep -q $ANSWER1 body
    if [ $? -eq 0 ]; then
        grep -q $ANSWER2 body
        if [ $? -eq 0 ]; then
            grep -q $ANSWER3 body
            if [ $? -eq 0 ]; then
                echo "Test [15]: OK"; SCORE=$(expr $SCORE + 1)
            else
                echo "Test [15]: FAIL"
            fi
        else
            echo "Test [15]: FAIL"
        fi
    else
        echo "Test [15]: FAIL"
    fi
else
    echo "Test [15]: FAIL (" $STATUS "!= 200 )"
fi

###############################################################
## Test [16]: delete                                         ##
###############################################################
ID="B3"
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X DELETE -w "%{http_code}" $RESOURCE)
if [ $STATUS == "204" ]; then
    echo "Test [16]: OK"; SCORE=$(expr $SCORE + 1)
else
    echo "Test [16]: FAIL (" $STATUS "!= 204 )"
fi

###############################################################
## Test [17]: delete                                         ##
###############################################################
ID="B3"
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X DELETE -o body -w "%{http_code}" $RESOURCE)
if [ $STATUS == "404" ]; then
    echo "Test [17]: OK"; SCORE=$(expr $SCORE + 1)
else
    echo "Test [17]: FAIL (" $STATUS "!= 404 )"
fi

###############################################################
## Test [18]: read                                           ##
###############################################################
ID="D4"
ANSWER="\"formula\":\"180.0\""
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X GET -o body -w "%{http_code}" $RESOURCE)
if [ $STATUS == "200" ]; then
    grep -q $ANSWER body
    if [ $? -eq 0 ]; then
        echo "Test [18]: OK"; SCORE=$(expr $SCORE + 1)
    else
        echo "Test [18]: FAIL"
    fi
else
    echo "Test [18]: FAIL (" $STATUS "!= 200 )"
fi

###############################################################
## Test [19]: list                                           ##
###############################################################
RESOURCE=$HOST/cells
ANSWER1="B2"
ANSWER2="B3"
ANSWER3="D4"

STATUS=$(curl -s -X GET -o body -w "%{http_code}" $RESOURCE)
if [ $STATUS == "200" ]; then
    grep -q $ANSWER1 body
    if [ $? -eq 0 ]; then
        grep -q $ANSWER2 body
        if [ $? -ne 0 ]; then
            grep -q $ANSWER3 body
            if [ $? -eq 0 ]; then
                echo "Test [19]: OK"; SCORE=$(expr $SCORE + 1)
            else
                echo "Test [19]: FAIL"
            fi
        else
            echo "Test [19]: FAIL"
        fi
    else
        echo "Test [19]: FAIL"
    fi
else
    echo "Test [19]: FAIL (" $STATUS "!= 200 )"
fi

###############################################################
## Test [20]: delete                                         ##
###############################################################
ID="A9"
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X DELETE -w "%{http_code}" $RESOURCE)
if [ $STATUS == "404" ]; then
    echo "Test [20]: OK"; SCORE=$(expr $SCORE + 1)
else
    echo "Test [20]: FAIL (" $STATUS "!= 404 )"
fi

###############################################################
## Test [21]: delete                                         ##
###############################################################
ID="B2"
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X DELETE -w "%{http_code}" $RESOURCE)
if [ $STATUS == "204" ]; then
    echo "Test [21]: OK"; SCORE=$(expr $SCORE + 1)
else
    echo "Test [21]: FAIL (" $STATUS "!= 204 )"
fi

###############################################################
## Test [22]: delete                                         ##
###############################################################
ID="B2"
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X DELETE -w "%{http_code}" $RESOURCE)
if [ $STATUS == "404" ]; then
    echo "Test [22]: OK"; SCORE=$(expr $SCORE + 1)
else
    echo "Test [22]: FAIL (" $STATUS "!= 404 )"
fi

###############################################################
## Test [23]: list                                           ##
###############################################################
RESOURCE=$HOST/cells
ANSWER1="B2"
ANSWER2="B3"
ANSWER3="D4"

STATUS=$(curl -s -X GET -o body -w "%{http_code}" $RESOURCE)
if [ $STATUS == "200" ]; then
    grep -q $ANSWER1 body
    if [ $? -ne 0 ]; then
        grep -q $ANSWER2 body
        if [ $? -ne 0 ]; then
            grep -q $ANSWER3 body
            if [ $? -eq 0 ]; then
                echo "Test [23]: OK"; SCORE=$(expr $SCORE + 1)
            else
                echo "Test [23]: FAIL"
            fi
        else
            echo "Test [23]: FAIL"
        fi
    else
        echo "Test [23]: FAIL"
    fi
else
    echo "Test [23]: FAIL (" $STATUS "!= 200 )"
fi

###############################################################
## Test [24]: update                                         ##
###############################################################
ID="B2"; FORMULA="-2 + 9 * 3"
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X PUT -d "{\"id\":\"$ID\",\"formula\":\"$FORMULA\"}" \
    -H "Content-Type: application/json" -w "%{http_code}" $RESOURCE)
if [ $STATUS == "201" ]; then
    echo "Test [24]: OK"; SCORE=$(expr $SCORE + 1)
else
    echo "Test [24]: FAIL (" $STATUS "!= 201 )"
fi

###############################################################
## Test [25]: update                                         ##
###############################################################
ID="B3"; FORMULA="(200 / 5) / 10"
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X PUT -d "{\"id\":\"$ID\",\"formula\":\"$FORMULA\"}" \
    -H "Content-Type: application/json" -w "%{http_code}" $RESOURCE)
if [ $STATUS == "201" ]; then
    echo "Test [25]: OK"; SCORE=$(expr $SCORE + 1)
else
    echo "Test [25]: FAIL (" $STATUS "!= 201 )"
fi

###############################################################
## Test [26]: update                                         ##
###############################################################
ID="D4"; FORMULA="B2 + B3 + 31"
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X PUT -d "{\"id\":\"$ID\",\"formula\":\"$FORMULA\"}" \
    -H "Content-Type: application/json" -w "%{http_code}" $RESOURCE)
if [ $STATUS == "204" ]; then
    echo "Test [26]: OK"; SCORE=$(expr $SCORE + 1)
else
    echo "Test [26]: FAIL (" $STATUS "!= 204 )"
fi

###############################################################
## Test [27]: read                                           ##
###############################################################
ID="D4"
ANSWER="\"formula\":\"60.0\""
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X GET -o body -w "%{http_code}" $RESOURCE)
if [ $STATUS == "200" ]; then
    grep -q $ANSWER body
    if [ $? -eq 0 ]; then
        echo "Test [27]: OK"; SCORE=$(expr $SCORE + 1)
    else
        echo "Test [27]: FAIL"
    fi
else
    echo "Test [27]: FAIL (" $STATUS "!= 200 )"
fi

###############################################################
## Test [28]: list                                           ##
###############################################################
RESOURCE=$HOST/cells
ANSWER1="B2"
ANSWER2="B3"
ANSWER3="D4"

STATUS=$(curl -s -X GET -o body -w "%{http_code}" $RESOURCE)
if [ $STATUS == "200" ]; then
    grep -q $ANSWER1 body
    if [ $? -eq 0 ]; then
        grep -q $ANSWER2 body
        if [ $? -eq 0 ]; then
            grep -q $ANSWER3 body
            if [ $? -eq 0 ]; then
                echo "Test [28]: OK"; SCORE=$(expr $SCORE + 1)
            else
                echo "Test [28]: FAIL"
            fi
        else
            echo "Test [28]: FAIL"
        fi
    else
        echo "Test [28]: FAIL"
    fi
else
    echo "Test [28]: FAIL (" $STATUS "!= 200 )"
fi

###############################################################
## Test [29]: delete                                         ##
###############################################################
ID="B3"
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X DELETE -o body -w "%{http_code}" $RESOURCE)
if [ $STATUS == "204" ]; then
    echo "Test [29]: OK"; SCORE=$(expr $SCORE + 1)
else
    echo "Test [29]: FAIL (" $STATUS "!= 204 )"
fi

###############################################################
## Test [30]: read                                           ##
###############################################################
ID="D4"
ANSWER="\"formula\":\"56\""
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X GET -o body -w "%{http_code}" $RESOURCE)
if [ $STATUS == "200" ]; then
    grep -q $ANSWER body
    if [ $? -eq 0 ]; then
        echo "Test [30]: OK"; SCORE=$(expr $SCORE + 1)
    else
        echo "Test [30]: FAIL"
    fi
else
    echo "Test [30]: FAIL (" $STATUS "!= 200 )"
fi

###############################################################
## Test [31]: update                             	     ##
###############################################################
ID="B2"; FORMULA="400 / 20 + 9 * 3"
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X PUT -d "{\"id\":\"$ID\",\"formula\":\"$FORMULA\"}" \
    -H "Content-Type: application/json" -w "%{http_code}" $RESOURCE)
if [ $STATUS == "204" ]; then
    echo "Test [31]: OK"; SCORE=$(expr $SCORE + 1)
else
    echo "Test [31]: FAIL (" $STATUS "!= 204 )"
fi

###############################################################
## Test [32]: update                             	     ##
###############################################################
ID="B3"; FORMULA="1 + 200 / 100 + 500 / 250"
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X PUT -d "{\"id\":\"$ID\",\"formula\":\"$FORMULA\"}" \
    -H "Content-Type: application/json" -w "%{http_code}" $RESOURCE)
if [ $STATUS == "201" ]; then
    echo "Test [32]: OK"; SCORE=$(expr $SCORE + 1)
else
    echo "Test [32]: FAIL (" $STATUS "!= 201 )"
fi

###############################################################
## Test [33]: update                             	     ##
###############################################################
ID="D4"; FORMULA="B2 + B2 + B3 + B3"
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X PUT -d "{\"id\":\"$ID\",\"formula\":\"$FORMULA\"}" \
    -H "Content-Type: application/json" -w "%{http_code}" $RESOURCE)
if [ $STATUS == "204" ]; then
    echo "Test [33]: OK"; SCORE=$(expr $SCORE + 1)
else
    echo "Test [33]: FAIL (" $STATUS "!= 204 )"
fi

###############################################################
## Test [34]: read                                           ##
###############################################################
ID="D4"
ANSWER="\"formula\":\"104.0\""
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X GET -o body -w "%{http_code}" $RESOURCE)
if [ $STATUS == "200" ]; then
    grep -q $ANSWER body
    if [ $? -eq 0 ]; then
        echo "Test [34]: OK"; SCORE=$(expr $SCORE + 1)
    else
        echo "Test [34]: FAIL"
    fi
else
    echo "Test [34]: FAIL (" $STATUS "!= 200 )"
fi

###############################################################
## Test [35]: delete                                         ##
###############################################################
ID="B3"
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X DELETE -o body -w "%{http_code}" $RESOURCE)
if [ $STATUS == "204" ]; then
    echo "Test [35]: OK"; SCORE=$(expr $SCORE + 1)
else
    echo "Test [35]: FAIL (" $STATUS "!= 204 )"
fi

###############################################################
## Test [36]: read                                           ##
###############################################################
ID="D4"
ANSWER="\"formula\":\"94.0\""
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X GET -o body -w "%{http_code}" $RESOURCE)
if [ $STATUS == "200" ]; then
    grep -q $ANSWER body
    if [ $? -eq 0 ]; then
        echo "Test [36]: OK"; SCORE=$(expr $SCORE + 1)
    else
        echo "Test [36]: FAIL"
    fi
else
    echo "Test [36]: FAIL (" $STATUS "!= 200 )"
fi

###############################################################
## Test [37]: list                                           ##
###############################################################
RESOURCE=$HOST/cells
ANSWER1="B2"
ANSWER2="D4"

STATUS=$(curl -s -X GET -o body -w "%{http_code}" $RESOURCE)
if [ $STATUS == "200" ]; then
    grep -q $ANSWER1 body
    if [ $? -eq 0 ]; then
        grep -q $ANSWER2 body
        if [ $? -eq 0 ]; then
            echo "Test [37]: OK"; SCORE=$(expr $SCORE + 1)
        else
            echo "Test [37]: FAIL"
        fi
    else
        echo "Test [37]: FAIL"
    fi
else
    echo "Test [37]: FAIL (" $STATUS "!= 200 )"
fi

###############################################################
## Test [38]: delete                                         ##
###############################################################
ID="B2"
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X DELETE -o body -w "%{http_code}" $RESOURCE)
if [ $STATUS == "204" ]; then
    echo "Test [38]: OK"; SCORE=$(expr $SCORE + 1)
else
    echo "Test [38]: FAIL (" $STATUS "!= 204 )"
fi

###############################################################
## Test [39]: update                             	     ##
###############################################################
ID="B2"; FORMULA="-(1 + 1) * -(((2 + 2)))"
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X PUT -d "{\"id\":\"$ID\",\"formula\":\"$FORMULA\"}" \
    -H "Content-Type: application/json" -w "%{http_code}" $RESOURCE)
if [ $STATUS == "201" ]; then
    echo "Test [39]: OK"; SCORE=$(expr $SCORE + 1)
else
    echo "Test [39]: FAIL (" $STATUS "!= 201 )"
fi

###############################################################
## Test [40]: update                             	     ##
###############################################################
ID="B3"; FORMULA="200 / 40 + 30 / 6"
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X PUT -d "{\"id\":\"$ID\",\"formula\":\"$FORMULA\"}" \
    -H "Content-Type: application/json" -w "%{http_code}" $RESOURCE)
if [ $STATUS == "201" ]; then
    echo "Test [40]: OK"; SCORE=$(expr $SCORE + 1)
else
    echo "Test [40]: FAIL (" $STATUS "!= 201 )"
fi

###############################################################
## Test [41]: update                             	     ##
###############################################################
ID="D4"; FORMULA="8 + (2 * B3) + B2 / 2"
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X PUT -d "{\"id\":\"$ID\",\"formula\":\"$FORMULA\"}" \
    -H "Content-Type: application/json" -w "%{http_code}" $RESOURCE)
if [ $STATUS == "204" ]; then
    echo "Test [41]: OK"; SCORE=$(expr $SCORE + 1)
else
    echo "Test [41]: FAIL (" $STATUS "!= 204 )"
fi

###############################################################
## Test [42]: read                                           ##
###############################################################
ID="D4"
ANSWER="\"formula\":\"32.0\""
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X GET -o body -w "%{http_code}" $RESOURCE)
if [ $STATUS == "200" ]; then
    grep -q $ANSWER body
    if [ $? -eq 0 ]; then
        echo "Test [42]: OK"; SCORE=$(expr $SCORE + 1)
    else
        echo "Test [42]: FAIL"
    fi
else
    echo "Test [42]: FAIL (" $STATUS "!= 200 )"
fi

###############################################################
## Test [43]: update                             	     ##
###############################################################
ID="B3"; FORMULA="-16 + (B2)"
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X PUT -d "{\"id\":\"$ID\",\"formula\":\"$FORMULA\"}" \
    -H "Content-Type: application/json" -w "%{http_code}" $RESOURCE)
if [ $STATUS == "204" ]; then
    echo "Test [43]: OK"; SCORE=$(expr $SCORE + 1)
else
    echo "Test [43]: FAIL (" $STATUS "!= 204 )"
fi

###############################################################
## Test [44]: read                                           ##
###############################################################
ID="D4"
ANSWER="\"formula\":\"-4.0\""
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X GET -o body -w "%{http_code}" $RESOURCE)
if [ $STATUS == "200" ]; then
    grep -q $ANSWER body
    if [ $? -eq 0 ]; then
        echo "Test [44]: OK"; SCORE=$(expr $SCORE + 1)
    else
        echo "Test [44]: FAIL"
    fi
else
    echo "Test [44]: FAIL (" $STATUS "!= 200 )"
fi

###############################################################
## Test [45]: update                             	     ##
###############################################################
ID="B2"; FORMULA="2 * N1 + (3 * N2) + 5 * N3 + 42"
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X PUT -d "{\"id\":\"$ID\",\"formula\":\"$FORMULA\"}" \
    -H "Content-Type: application/json" -w "%{http_code}" $RESOURCE)
if [ $STATUS == "204" ]; then
    echo "Test [45]: OK"; SCORE=$(expr $SCORE + 1)
else
    echo "Test [45]: FAIL (" $STATUS "!= 204 )"
fi

###############################################################
## Test [46]: read                                           ##
###############################################################
ID="N2"
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X GET -o body -w "%{http_code}" $RESOURCE)
if [ $STATUS == "404" ]; then
    echo "Test [46]: OK"; SCORE=$(expr $SCORE + 1)
else
    echo "Test [46]: FAIL (" $STATUS "!= 404 )"
fi

###############################################################
## Test [47]: delete                                         ##
###############################################################
ID="B2"
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X DELETE -o body -w "%{http_code}" $RESOURCE)
if [ $STATUS == "204" ]; then
    echo "Test [47]: OK"; SCORE=$(expr $SCORE + 1)
else
    echo "Test [47]: FAIL (" $STATUS "!= 204 )"
fi

###############################################################
## Test [48]: delete                                         ##
###############################################################
ID="B3"
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X DELETE -o body -w "%{http_code}" $RESOURCE)
if [ $STATUS == "204" ]; then
    echo "Test [48]: OK"; SCORE=$(expr $SCORE + 1)
else
    echo "Test [48]: FAIL (" $STATUS "!= 204 )"
fi

###############################################################
## Test [49]: delete                                         ##
###############################################################
ID="D4"
RESOURCE=$HOST/cells/$ID

STATUS=$(curl -s -X DELETE -o body -w "%{http_code}" $RESOURCE)
if [ $STATUS == "204" ]; then
    echo "Test [49]: OK"; SCORE=$(expr $SCORE + 1)
else
    echo "Test [49]: FAIL (" $STATUS "!= 204 )"
fi

###############################################################
## Test [50]: list                                            ##
###############################################################
RESOURCE=$HOST/cells
ANSWER="\[\]"

STATUS=$(curl -s -X GET -o body -w "%{http_code}" $RESOURCE)
if [ $STATUS == "200" ]; then
    grep -q $ANSWER body
    if [ $? -eq 0 ]; then
        echo "Test [50]: OK"; SCORE=$(expr $SCORE + 1)
    else
        echo "Test [50]: FAIL"
    fi
else
    echo "Test [50]: FAIL (" $STATUS "!= 200 )"
fi

echo "** Overall score:" $SCORE "**"
