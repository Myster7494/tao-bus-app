import json

operators: list[dict] = json.load(open('origin/operator_data.json', 'r', encoding='utf-8'))
new_operators = {}
for operator in operators:
    new_operator = {'OperatorName': operator['OperatorName'], 'OperatorPhone': operator['OperatorPhone'],
                    'OperatorUrl': operator['OperatorUrl']}
    new_operators[operator['OperatorNo']] = new_operator
json.dump(new_operators, open('out/operator_data.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=2)
