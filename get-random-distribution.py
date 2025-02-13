#!/usr/bin/python3

import sys
import random


def read_random_lines(file_path, num_lines):
    """
    Read random lines from a file.

    Args:
        file_path (str): Path to the text file
        num_lines (int): Number of random lines to select

    Returns:
        list: Selected random lines
    """
    try:
        # First, count total lines in file
        with open(file_path, "r") as file:
            total_lines = sum(1 for _ in file)

        # Generate random line numbers
        if num_lines > total_lines:
            print(
                f"Warning: Requested {num_lines} lines but file only has {total_lines} lines."
            )
            num_lines = total_lines

        random_indices = random.sample(range(total_lines), num_lines)

        # Read the selected lines
        selected_lines = []
        with open(file_path, "r") as file:
            for idx, line in enumerate(file):
                if idx in random_indices:
                    print(line.rstrip())

    except FileNotFoundError:
        print(f"Error: File '{file_path}' not found.")
        sys.exit(1)
    except ValueError as e:
        print(f"Error: {str(e)}")
        sys.exit(1)
    except Exception as e:
        print(f"An unexpected error occurred: {str(e)}")
        sys.exit(1)


def main():
    # Check command line arguments
    if len(sys.argv) != 3:
        print("Usage: python script.py <file_path> <number_of_lines>")
        sys.exit(1)

    file_path = sys.argv[1]

    try:
        num_lines = int(sys.argv[2])
        if num_lines < 1:
            print("Error: Number of lines must be positive.")
            sys.exit(1)
    except ValueError:
        print("Error: Number of lines must be an integer.")
        sys.exit(1)

    # Print random lines
    read_random_lines(file_path, num_lines)


if __name__ == "__main__":
    main()
