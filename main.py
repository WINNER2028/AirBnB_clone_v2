#!/usr/bin/python3
from models import storage
from models.state import State

# Check the number of existing State objects in the storage
print(len(storage.all(State)))  # Output: 5

# Check the number of existing State objects again
print(len(storage.all(State)))  # Output: 5

# Time to insert new data!
# You can insert new data as explained in the previous response
