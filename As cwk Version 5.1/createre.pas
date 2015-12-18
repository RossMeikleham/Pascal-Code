PROGRAM BookingRecords;

 USES BOOKDAT;

   VAR
      Book        :BookingInfo;
      BookingFile :FILE OF BookingInfo;


  PROCEDURE CreateBookingFile;
     BEGIN
        ASSIGN(BookingFile,'D:\AsShizzle\BOOKINGS.DTA');
        REWRITE(BookingFile);

        WITH Book DO
           BEGIN
              BookingNo         :='ABCD123';
              Surname           :='Smithers';
              Forename          :='Jessica';
              Gender            :='F';
              PhoneNo           :='01908123456';
              HouseNoOrTitle    :='4';
              Street            :='Brook Street';
              CityOrTown        :='Milton Keynes';
              County            :='Buckinghamshire';
              PostCode          :='MK30JK';
              Origin            :='Milton Keynes';
              Destination       :='Glasgow';
              DayTravel         :='N';
              HoursTravelling   :=6;
              Mileage           :=360;
              WaitingTime       :=0;
              NoOfNights        :=1;
              MilesCost         :=211.25;
              HoursCost         :=150;
              WaitingCost       :=0;
              OvernightCharge   :=200;
              TotalCost         :=716.45;
              Paid              :='Y';


              WRITE(BookingFile, Book);


              BookingNo         :='ABCD568';
              Surname           :='Petekins';
              Forename          :='John';
              Gender            :='M';
              PhoneNo           :='01987654321';
              HouseNoOrTitle    :='36';
              Street            :='Timbold Drive';
              CityOrTown        :='Portsmouth';
              County            :='Hampshire';
              PostCode          :='PM30JK';
              Origin            :='Portsmouth';
              Destination       :='Cardiff';
              DayTravel         :='D';
              HoursTravelling   :=3;
              Mileage           :=160;
              WaitingTime       :=1;
              NoOfNights        :=0;
              MilesCost         :=172.45;
              HoursCost         :=75;
              WaitingCost       :=20.5;
              OvernightCharge   :=0;
              TotalCost         :=267.95;
              Paid              :='Y';

              WRITE(BookingFile, Book);


              BookingNo         :='ABCD569';
              Surname           :='Ian';
              Forename          :='Bob';
              Gender            :='M';
              PhoneNo           :='01843019385';
              HouseNoOrTitle    :='7';
              Street            :='Ferry Road';
              CityOrTown        :='Edinburgh';
              County            :='Midlothian';
              PostCode          :='EB89BD';
              Origin            :='West Linton';
              Destination       :='Gretna';
              DayTravel         :='D';
              HoursTravelling   :=2;
              Mileage           :=73;
              WaitingTime       :=2;
              NoOFNights        :=0;
              MilesCost         :=87.6;
              HoursCost         :=50;
              WaitingCost       :=41;
              OvernightCharge   :=0;
              TotalCost         :=178.60;
              Paid              :='N';

              WRITE(BookingFile, Book);

          END;
       CLOSE(BookingFile);
    END;

BEGIN
   CreateBookingFile;
END.
