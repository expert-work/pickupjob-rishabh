# pickupjob

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.




TO Drwa lines :

https://pub.dev/packages/google_maps_widget


Job Status : 
------------
Open: This is the status when job is created 
In Process: when user Hire a driver but pickup is not initiated 



Steps after confirmimg picup job by User 
-----------------------------------------
-----------------------------------------

User:

1: User Can see driver detail, vehicle detail 
2. when driver start comming picup job user will see msg "Buddy is on the way, 35 min arrival time "
3.Buddy is on the site see id
4. Picture of driver id
5. Buddy Confirms pickup at first pickupjob, click here to confirm  generator is <IN/ON> <PICKUP>
6. Confirm pickup job

7. <BUDDY> delivering pickupjob to drop of site estimate [35 MINutes]
8. <BUDDY> is at the drop off site. click here to confirm  the load is delivered 
9. Confirm Delivery 
10. Ready To Pay Driver 
11. Confirm Payment 
12 payment
13. on success "Add <buddy>" to favourite list (Yes or no)


Driver:
1. After hired by user when driver start go to pivkup job (I am on the way to pickupjob located at "Abc india luknow 5645456")
2. once driver at the location (I am at the location first point for the pickup job-- "Confirm")
3.Take a pic of pickup job on your truck
4. confirm Pickup job
5 On  way to deliver the final pickup job- abc f kanpur 987897
6. once reach at location "I am at the drop off site and deliver the picjup job"
7. confirm delivery 
8 After payment recipet will show
9 Rationg 
10. nice pickup job Add client to your favourite ?



"Way to Pickup"  : this button will be shown when user click in progress jobs list jobs,
Story:

When Driver Start to go Pick the job,  he/she have to click the Button "Way to Pickup"


Once Driver click on "Way to Pickup" ,  User will she a message "Buddy is on the way, 35 min arrival time"

When driver reach at "Pickup location"  Driver have to click "I am at pickup loaction"

once Driver Click "I am at pickup loaction"  user will see a msg  "Driver at pickup Location" and  a button will be enabled "Picture of driver id",
on clicking button "Picture Of Driver ID" user have to click driver image with his driver id

Driver will seee:

Image of Pickup  Job
Image of Pickup Job on Truck

And Then Driver will See "confirm Pickup job"
once Driver click on "Confirm  Pickup Job" ::

user will see Mr Driver is on the way from Pickup poiny to Drop Point 


Once Driver Reach at Pickup Location He have to click "I am at the drop off site and deliver the picjup job" then user will see Messge  "I am at the drop off site and deliver the picjup job"


Then Driver need click "Confirm Delivery"



Then User will see msg "Pickup job is delivered"   

Once Pckup job is delivered user wiil see "Ready to release payment"
once psyment maid  job status wiil be chabge to "Compleated"


Inprogress table structure



InProgressJobs 
--------------

user_id
user_name
driver_id
driver_name
vehicle_id
vehicle_name
job_id
job_title
pickup_lat_lan
drop_lat_lan

driver_on_way_to_pickup
driver_at_pickup_location
user_picture_of_driver_with_driver_id
driver_image_of_pickup_job
driver_image_of_pickup_job_on_truck
user_confirm_pickup_job
driver_at_drop_off_loaction
driver_pickupjob_delivered
user_release_payment 
rating_to_driver
rating_to_user
review_for_customer 
review_for_user






//////////////////////////////////////////////////
Chat List
---------
id
chat_id (jobid_userid_driverid)
user_id
user_name
user_image
driver_id
driver_name
driver_image
job_id
job_title
updatedon
createdon
status


Chat
----

chat_id
user_id
driver_id
job_id
message 
send_by (driver/user)
status
type (image/text/file)
updatedon
createdon


background Location : 


 latitude = location.latitude.toString();
                        longitude = location.longitude.toString();
                        accuracy = location.accuracy.toString();
                        altitude = location.altitude.toString();
                        bearing = location.bearing.toString();
                        speed = location.speed.toString();
                        time = DateTime.fromMillisecondsSinceEpoch(
                                location.time!.toInt())
                            .toString();



flutter pub add geo_firestore_flutter
https://pub.dev/packages/geo_firestore_flutter/install




Payment Sytems 
-----------------
-------------------------

Add Card 

When user Add card We just need to save in firebase 

When need to pay 


Card Details 

 
user_id
name_on_card
card_number
expiry_date
is_default
updatedon
createdon

//////T
Transctions 

