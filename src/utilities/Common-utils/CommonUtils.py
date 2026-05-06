import datetime
import math
import random
from robot.api.deco import keyword
import re



@keyword('get xpath')
def getxpath(xpath, string, unique):
    print(type(xpath), xpath)
    print(type(string), string)

    xpath = xpath.replace(unique, string)
    print(xpath)
    return xpath


@keyword('get value from dict')
def getvaluefromdict(json, key):
    return json[key]


@keyword('get data from json')
def getdatafromjson(data):
    if not data:
        return 0
    else:
        return len(data)


@keyword('convert millisecond to time')
def convertmillisecondtotime(data):
    if isinstance(data, str):
        data=int(math.floor(float(data)))
    minutes, seconds = divmod(data, 60)
    hours, minutes = divmod(minutes, 60)
    dt = datetime.time(hours, minutes, seconds)
    dt=dt.strftime("%H:%M:%S")
    return dt

@keyword('calculatePercent')
def calculatePercent(activetime,waittime):
    activetime=float(activetime)
    waittime=float(waittime)
    total=activetime+waittime
    percentage=(activetime/total)*100
    percentage="{:.2f}".format(percentage)
    return str(percentage)

@keyword('StripTrailingSpace')
def StripTrailingSpace(data):
    return  data.strip()


@keyword('Check The Strings Are Equal')
def check_if_string_equal(str1, str2):
    if  str(str1).strip()== str(str2).strip():
        pass
    else :
        raise Exception

@keyword('Generate Random Number Between Range As String')
def generate_random_number_between_range(lb, ub):
    random_number = random.randint(int(lb), int(ub))
    return str(random_number)


@keyword('Get Random Email')
def get_random_email(base_email):
    return base_email+'@mailinator.com'


@keyword('Get User Full Name From FN LN')
def get_full_name(first_name, last_name):
    return str(first_name)+" "+str(last_name)


@keyword('Strip The String')
def get_string_striped(input_str):
    return input_str.strip()


@keyword('Strip The String')
def get_string_striped(input_str):
    return input_str.strip()


@keyword('Get Upper Bound')
def get_upper_bound(inp1, inp2):
    if int(inp1) <int(inp2):
        return inp1
    else:
        return inp2

@keyword('Get The Smaller Value')
def get_smaller_value(inp1, inp2):
    if int(inp1) < int(inp2):
        print(inp1)
        return inp1
    else:
        print(inp2)
        return inp2

@keyword('Extract Numbers')
def remove_non_numbers(input_string):
    return ''.join(re.findall(r'\d', input_string))


@keyword('Check The Count Is Changed')
def check_the_count_is_changed(prev, curr, cf):
    print(prev)
    print(curr)
    print(cf)
    cf=str(cf)
    if cf=='0':
        count=0
    else:
        count = int(cf[1:])

    curr = int(curr)
    if cf.startswith("+"):
        cal_curr=int(prev) + count
    if cf.startswith("-"):
        cal_curr=int(prev) - count
    if int(prev)==int(curr) and cf=='0':
        print(f"prev: {prev},curr: {curr}")
    elif curr==cal_curr:
        print(f"curr: {curr},cal_curr: {cal_curr}")
    else:
        raise Exception



@keyword('Remove Trailing Dots')
def remove_trailing_dots(inp_str):
    if inp_str.endswith("..."):
        s = inp_str[:-3]
    else :
        s=inp_str
    return s

@keyword('Get Release Type')
def get_release_type():
    releases = ['minor','major']

    # Select random items from each list
    release_type = random.choice(releases)
    return  release_type


@keyword('Get Lower Bound')
def get_lower_bound(input_value):
    temp=int(input_value)
    if  temp<10:
        return temp
    else:
        return 10


@keyword('Get Version Number')
def get_version_number(input_str):
    ver = input_str.split(':')[1]
    ver = ver.strip()
    return ver

@keyword('Get Procedure Name Version')
def get_procedure_name_version(procedure_name, version):
    return f"{procedure_name} (Ver : {version})"

@keyword('Generate Random Statement')
def generate_random_statement():
    # Categories of phrases
    industries = ["manufacturing", "automotive", "construction", "energy", "mechanical engineering"]
    companies = ["TechCorp", "BuildMasters", "AutoWorks", "EnergyPro", "MechDesign"]
    workers = ["workers", "engineers", "technicians", "supervisors", "machinists"]
    actions = ["undergo training", "perform maintenance", "assemble parts", "design systems", "inspect machinery"]
    tools = ["wrenches", "drills", "CAD software", "welding equipment", "power tools"]
    locations = ["on the assembly line", "in the workshop", "at the construction site", "at the plant", "in the control room"]

    # Select random items from each list
    industry = random.choice(industries)
    company = random.choice(companies)
    worker = random.choice(workers)
    action = random.choice(actions)
    tool = random.choice(tools)
    location = random.choice(locations)

    # Combine them into a statement
    return f"In the {industry} sector, {company} has {worker} who {action} using {tool} {location}."


@keyword('Get Current Release Version')
def get_current_release_version(release_type, prv_version):
    temp=str(prv_version).split('.')
    prv_version=float(prv_version)
    if len(temp)==1:
        prev_release='major'
    else:
        prev_release='minor'

    if  prev_release!='major':
        if  release_type!='minor':
            res=float(int(prv_version)+1)
        else:
            res=prv_version+0.1
    elif  prev_release=='major':
        if  release_type=='minor':
            res=prv_version+0.1
        else:
            res=float(int(prv_version)+1)

    return round(res, 1)

@keyword('Generate Random Options')
def generate_random_options(count):
    count=int(count)
    question_bank = [
        {
            "question": "Which tool are you currently using?",
            "options": ["Wrench", "Drill", "CAD software", "Welding machine", "Power tools"]
        },
        {
            "question": "Where are you currently working?",
            "options": ["Assembly line", "Workshop", "Construction site", "Control room", "Plant"]
        },
        {
            "question": "Which company’s procedure are you following?",
            "options": ["TechCorp", "BuildMasters", "AutoWorks", "EnergyPro", "MechDesign"]
        },
        {
            "question": "What action are you performing?",
            "options": ["Assembling", "Maintaining", "Inspecting", "Designing", "Operating"]
        },
        {
            "question": "What is your current role?",
            "options": ["Technician", "Engineer", "Machinist", "Supervisor", "Welder"]
        },
        {
            "question": "Which software are you using for design?",
            "options": ["AutoCAD", "SolidWorks", "Fusion 360", "CATIA", "Inventor"]
        },
        {
            "question": "Which department are you working in?",
            "options": ["Production", "Design", "Quality", "Maintenance", "Logistics"]
        },
        {
            "question": "Where will you perform the next inspection?",
            "options": ["Assembly line", "Workshop", "Construction site", "Control room", "Plant"]
        },
        {
            "question": "Which tool is most used in your task?",
            "options": ["Wrench", "Drill", "CAD software", "Welding machine", "Power tools"]
        },
        {
            "question": "What personal protective equipment are you using?",
            "options": ["Gloves", "Helmet", "Goggles", "Boots", "Ear protection"]
        }
    ]

    # Ensure count is not more than available questions
    count = min(count, len(question_bank))

    # Randomly select the questions
    selected = random.sample(question_bank, count)

    # Convert to dict format: {question: options}
    result = {item["question"]: item["options"] for item in selected}

    return result


@keyword('Get Instruction Language')
def get_instruction_language():
    instruction_bank = [
        {
            "Language": "Chinese",
            "Text": "这是步骤说明。"
        },
        {
            "Language": "Portuguese",
            "Text": "Esta é a instrução da etapa."
        },
        {
            "Language": "English",
            "Text": "This is the step instruction."
        },
        {
            "Language": "German",
            "Text": "Das ist die Schrittanweisung."
        },
        {
            "Language": "French",
            "Text": "Il s’agit de l’instruction d’étape."
        },
        {
            "Language": "Spanish",
            "Text": "Esta es la instrucción del paso."
        },
        {
            "Language": "Polish",
            "Text": "To jest instrukcja krokowa."
        }
    ]


    # Randomly select
    selected = random.sample(instruction_bank, 1)[0]

    return selected["Language"] , selected["Text"]


@keyword('ENUMERATE LIST')
def enumerate_list_from_one(items):
    return [(i + 1, item) for i, item in enumerate(items)]

@keyword('Get Option Value Selected')
def get_option_value_selected(input_dict, index):
    temp_list=list(input_dict.values())[index]
    return random.choice(temp_list)

@keyword('Get Random Records From List')
def get_random_record_from_list(input_list, count):
    res=random.sample(input_list, int(count))
    out=[i.split('\n')[0] for i in res]
    return out

@keyword('Extend List')
def extend_list(list1, list2):
    list1.extend(list2)
    return  list1

@keyword('Validate Time Format')
def validate_time_format(estimated_time_list):
    # Regular expression pattern
    pattern = re.compile(r"^\d{1,2}h \d{1,2}m \d{1,2}s$")
    for each_time in estimated_time_list:
        if pattern.match(each_time):
            print(f"Valid format: {each_time}")
        else:
            print(f"Invalid format: {each_time}")


@keyword("Get Date From Date Time")
def get_date_from_date_time(ALL_COMPLETED_ON_DATES):
    return [date.split('|')[0].strip()  for date in ALL_COMPLETED_ON_DATES]

@keyword("Add Numbers")
def add_numbers(num1, num2):
    return int(num1)+int(num2)

@keyword("Subtract Numbers")
def subtract_numbers(num1, num2):
    return int(num1)-int(num2)





@keyword("Get Last Two Elements From List")
def get_last_two_elements_from_list(input_list):
    return input_list[-2:]


@keyword("Check If Not Empty")
def get_last_two_elements(input_str):
    if  input_str!='':
        return True
    else:
        return False


