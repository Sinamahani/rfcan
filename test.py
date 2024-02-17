from codes_RF.prep import PREP

box = [60, 75, -105, -80]
radius =[40, 90]
mag = [7.0, 8.0]
events = [2005, 2030]
year = 3 #years of data

PREP.preparation(box, radius, mag, events, year, verbose=False)
