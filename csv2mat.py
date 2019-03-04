import os
import sys
import csv


def main():

  with open("in/text.csv", 'r') as fd:
    csv_data = csv.reader(fd, delimiter=',')
    line_count = 0
    for row in csv_data:
      


if __name__ == "__main__":
  main()