import datetime
from datetime import date, timedelta

from robot.api.deco import keyword


@keyword('dateForLastdayOfPreviousMonth1')
def dateForLastdayOfPreviousMonth1():
    last_day_of_prev_month = date.today().replace(day=1) - timedelta(days=1)
    formatted_date = datetime.date.strftime(last_day_of_prev_month, "%d/%m/%Y")
    print("\n Formatted Date String:", formatted_date, "\n")
    return formatted_date


@keyword('dateForLastdayOfPreviousMonth2')
def dateForLastdayOfPreviousMonth2():
    last_day_of_prev_month = date.today().replace(day=1) - timedelta(days=1)
    formatted_date = datetime.date.strftime(last_day_of_prev_month, "%Y/%m/%d")
    print("\n Formatted Date String:", formatted_date, "\n")
    return formatted_date



