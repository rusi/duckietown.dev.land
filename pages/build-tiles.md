---
title: Build Duckietown
path: /build/duckietown/
---

<section>

# Building Duckietown

Anybody can build their own version of Duckietown. However, to be consistent and to avoid confusion
when Duckies travel from one town to another, every town should follow these rules.

Duckietown has two layers - Tiles and Signs:
* **Tiles**: The first layer is the floor layer. The floor is built of interconnected exercise mats with tape on them. 
* **Signes**: The second layer is signs and other objects that sit on top of the mats. 

**NOTE**: In the case that Duckietown directly abuts a wall, a perimeter of vertical tiles should be added to reduce visual clutter and false positives.
<!-- {p:.alert .alert-warning} -->

**NOTE**: The edge of each tile with a white piece of tape should also have a small curb (use the edge pieces that come with the mats for this). The purpose of this is to clearly delineate the white lanes and make lanes in adjacent roads less visible from the onboard camera. 
Moreover, the Duckiebot is not powerful enough to cross the curb, so the failure of one car causes only the current tile to become unavailable.
<!-- {p:.alert .alert-warning} -->

</section>

<section>

## Materials

Following is a list of materials required to build the tiles (~$140):

* <a target="_blank"  href="https://www.amazon.com/gp/product/B01IDRWPG8/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B01IDRWPG8&linkCode=as2&tag=duckietown-20&linkId=bb91b7d582c9da6c00d76d6a6a57df6d"><img border="0" src="//ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&MarketPlace=US&ASIN=B01IDRWPG8&ServiceVersion=20070822&ID=AsinImage&WS=1&Format=_SL250_&tag=duckietown-20" width="40" /> Foam Interlocking Tiles (2ft x 2ft) (B01IDRWPG8)</a><img src="//ir-na.amazon-adsystem.com/e/ir?t=duckietown-20&l=am2&o=1&a=B01IDRWPG8" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />

* <a target="_blank"  href="https://www.amazon.com/gp/product/B003YHBU1O/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B003YHBU1O&linkCode=as2&tag=duckietown-20&linkId=e37f66b7259c681bdf071b5984254f98"><img border="0" src="//ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&MarketPlace=US&ASIN=B003YHBU1O&ServiceVersion=20070822&ID=AsinImage&WS=1&Format=_SL250_&tag=duckietown-20" width="40" /> Duct Tape, Pearl White, 1.88-Inch (B003YHBU1O)</a><img src="//ir-na.amazon-adsystem.com/e/ir?t=duckietown-20&l=am2&o=1&a=B003YHBU1O" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />

* <a target="_blank"  href="https://www.amazon.com/gp/product/B000BOAAFA/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B000BOAAFA&linkCode=as2&tag=duckietown-20&linkId=d106b52d405330b242875a026dd0215b"><img border="0" src="//ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&MarketPlace=US&ASIN=B000BOAAFA&ServiceVersion=20070822&ID=AsinImage&WS=1&Format=_SL250_&tag=duckietown-20" width="40" /> Red Electrical Tape, 3/4-Inch (B000BOAAFA)</a><img src="//ir-na.amazon-adsystem.com/e/ir?t=duckietown-20&l=am2&o=1&a=B000BOAAFA" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />

* <a target="_blank"  href="https://www.amazon.com/gp/product/B000BQWLF0/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B000BQWLF0&linkCode=as2&tag=duckietown-20&linkId=6305eea6f8afaff8d89218b04fe76edc"><img border="0" src="//ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&MarketPlace=US&ASIN=B000BQWLF0&ServiceVersion=20070822&ID=AsinImage&WS=1&Format=_SL250_&tag=duckietown-20" width="40" /> Yellow Electrical Tape, 3/4-Inch (B000BQWLF0)</a><img src="//ir-na.amazon-adsystem.com/e/ir?t=duckietown-20&l=am2&o=1&a=B000BQWLF0" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />

---
Additional Items (~$45):

* <a target="_blank"  href="https://www.amazon.com/gp/product/B00YMRZNTA/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B00YMRZNTA&linkCode=as2&tag=duckietown-20&linkId=d7652215f74b7115d07953317ba850d6"><img border="0" src="http://ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&MarketPlace=US&ASIN=B00YMRZNTA&ServiceVersion=20070822&ID=AsinImage&WS=1&Format=_SL250_&tag=duckietown-20" width="40" /> Rubber Duckies (B00YMRZNTA)</a><img src="http://ir-na.amazon-adsystem.com/e/ir?t=duckietown-20&l=am2&o=1&a=B00YMRZNTA" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />

* <a target="_blank"  href="https://www.amazon.com/gp/product/B0039N6XVU/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B0039N6XVU&linkCode=as2&tag=duckietown-20&linkId=efca5a8e8046a115f45d8aa1115182ec"><img border="0" src="//ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&MarketPlace=US&ASIN=B0039N6XVU&ServiceVersion=20070822&ID=AsinImage&WS=1&Format=_SL250_&tag=duckietown-20" width="40" /> Course/Track Cones (B0039N6XVU)</a><img src="//ir-na.amazon-adsystem.com/e/ir?t=duckietown-20&l=am2&o=1&a=B0039N6XVU" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />

* <a target="_blank"  href="https://www.amazon.com/gp/product/B0012QRPY0/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B0012QRPY0&linkCode=as2&tag=duckietown-20&linkId=946f516ac36fec3d7fc06cdb0a4d50d7"><img border="0" src="//ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&MarketPlace=US&ASIN=B0012QRPY0&ServiceVersion=20070822&ID=AsinImage&WS=1&Format=_SL250_&tag=duckietown-20" width="40" /> Guidecraft 7" Block Play Traffic Signs (B0012QRPY0)</a><img src="//ir-na.amazon-adsystem.com/e/ir?t=duckietown-20&l=am2&o=1&a=B0012QRPY0" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />

</section>

<section>

# Buidling the Tiles

Each tile is a 2ft x 2ft interlock square. There are ~~four~~ **two** types of tiles:
* ![two lane](/images/tile-two-lane-small.jpg) **Two lane straight** tile
* ![curved](/images/tile-two-lane-90-small.jpg) **Curved 90°** tile
* ~~Three way intersection tile~~
* ~~Four way intersection tile~~

![simple-town](/images/simple-town.jpg)<!-- {.photo} -->

</section>

<section class="step">

## Making Two Lane Straight Tile

[![two lane straight](/images/tile-two-lane.jpg)](/images/tile-two-lane.jpg)

Use the white 1.88" (5cm) Duck Tape to create the outer borders. It is assumed that the **white strip is always on the right** side of the lane. Also, **the white strip is always solid**.

Start by placing markers at **2cm away from the inner edge** of the interlocking tile. Then place the white tape from one side of the tile to the other, covering the interlocking pieces.

**TIP**: Use two small pieces of tape to measure and mark the locations where the tape should be placed, as shown in the pictures below.
<!-- {p:.alert .alert-info} -->

[![tile-s-step1](/images/tile-s-step1.jpg)](/images/tile-s-step1.jpg)<!-- {.example} -->
[![tile-s-step2](/images/tile-s-step2.jpg)](/images/tile-s-step2.jpg)<!-- {.example .img-h} -->
<!-- {p:.center} -->

Cut **six 5cm** long pieces of yellow tape to create the median line. Place the first one **3cm** away from the inner edge of the tile and at **21cm** from the edge of the white line. The edge-to-edge distance between the medial line and the white line should be **21cm**.

[![tile-s-step5](/images/tile-s-step5.jpg)](/images/tile-s-step5.jpg)<!-- {.example .img-h} -->
[![tile-s-step6](/images/tile-s-step6.jpg)](/images/tile-s-step6.jpg)<!-- {.example .img-h} -->
<!-- {p:.center} -->

Place the other pieces **5cm apart** from each other in the middle of the tile as shows in the pictures.

[![tile-s-step7](/images/tile-s-step7.jpg)](/images/tile-s-step7.jpg)<!-- {.example} -->
[![tile-s-step8](/images/tile-s-step8.jpg)](/images/tile-s-step8.jpg)<!-- {.example} -->
[![tile-s-step9](/images/tile-s-step9.jpg)](/images/tile-s-step9.jpg)<!-- {.example} -->
<!-- {p:.center} -->

</section>

<section class="step">

## Making Two Lane 90° Curved Tile

[![step 1 - inner border](/images/tile-90-step1.jpg)](/images/tile-90-step1.jpg)

### Step 1 - Inner Border

Place **two 7cm** pieces of white 1.88" (5cm) Duck Tape to create the inner border. Tape each piece at **2cm** away from the inner edge of the interlocking tile as shown in the picture.

Start by measuring **2cm** and **7cm** away from the inner edge of the tile. Then place the white tape and cut around the tile.

[![tile-90s-step1](/images/tile-90s-step1.jpg)](/images/tile-90s-step1.jpg)<!-- {.example} -->
[![tile-90s-step2](/images/tile-90s-step2.jpg)](/images/tile-90s-step2.jpg)<!-- {.example} -->
[![tile-90s-step3](/images/tile-90s-step3.jpg)](/images/tile-90s-step3.jpg)<!-- {.example} -->
<!-- {p:.center} -->

Repeat to add the other side of the inner corner.

</section>

<section class="step">

[![step 2 - inner border](/images/tile-90-step2.jpg)](/images/tile-90-step2.jpg)

### Step 2 - Inner Border

Mark **3cm** away from the edge of the white border tape as shown in the picture and draw a line connecting the two marks. Note that the line connecting the two marks is **6cm**. Use scissors or a sharp knife to cut the border and form the border line.

[![tile-90s-step4.1](/images/tile-90s-step4.1.jpg)](/images/tile-90s-step4.1.jpg)<!-- {.example} -->
[![tile-90s-step4.2](/images/tile-90s-step4.2.jpg)](/images/tile-90s-step4.2.jpg)<!-- {.example} -->
[![tile-90s-step4.3](/images/tile-90s-step4.3.jpg)](/images/tile-90s-step4.3.jpg)<!-- {.example} -->
<!-- {p:.center} -->

</section>

<section class="step">

[![step 3 - outer border](/images/tile-90-step3.jpg)](/images/tile-90-step3.jpg)

### Step 3 - Outer Border

Place **two 14cm** pieces, **two 20cm** pieces, and **one 22cm** piece of white 1.88" (5cm) Duck Tape to create the outer borders. Place the tape pieces as shown in the picture.

First, place the two 14cm pieces. 

**NOTE** that the **14cm pieces are 2cm away** from the inner edge of the interlocking tile. 
<!-- {p:.alert .alert-warning} -->

[![tile-90s-step5](/images/tile-90s-step5.jpg)](/images/tile-90s-step5.jpg)<!-- {.example} -->
[![tile-90s-step6](/images/tile-90s-step6.jpg)](/images/tile-90s-step6.jpg)<!-- {.example} -->
[![tile-90s-step7](/images/tile-90s-step7.jpg)](/images/tile-90s-step7.jpg)<!-- {.example} -->
<!-- {p:.center} -->

Then, at about **18cm** away from the last tape strip, measure and place a marker at **10cm** away from the inner edge of the tile. Measure **20cm** white tape strip and place it connecting the outer edge of the last tape strip to the **10cm** mark that you just placed.

**NOTE** that the one corner of each piece overlaps with the adjacent pieces, however, the other corner is just touching. 
<!-- {p:.alert .alert-warning} -->

[![tile-90s-step10](/images/tile-90s-step10.jpg)](/images/tile-90s-step10.jpg)<!-- {.example} -->
[![tile-90s-step11](/images/tile-90s-step11.jpg)](/images/tile-90s-step11.jpg)<!-- {.example} -->
[![tile-90s-step12](/images/tile-90s-step12.jpg)](/images/tile-90s-step12.jpg)<!-- {.example} -->
<!-- {p:.center} -->

Repeat on the other side to add the **second 20cm strip**.

Finally, connect the edges of the 20cm strips with the **22cm strip**.

[![tile-90s-step13](/images/tile-90s-step13.jpg)](/images/tile-90s-step13.jpg)<!-- {.example} -->
[![tile-90s-step14](/images/tile-90s-step14.jpg)](/images/tile-90s-step14.jpg)<!-- {.example} -->
[![tile-90s-step15](/images/tile-90s-step15.jpg)](/images/tile-90s-step15.jpg)<!-- {.example} -->
<!-- {p:.center} -->

</section>

<section class="step">

[![step 4 - center](/images/tile-90-final.jpg)](/images/tile-90-final.jpg)

### Step 4 - Center line

The center line is made of **five 5cm strips** of **yellow tape**. The center line is at **21cm away** from each of the edges of the inner and outer white lines. Place the yellow strips according to the image.

Start by placing the middle strip. Then place the edge strips, and finally place the last strips so that they are all equally spaced.

[![tile-90s-step18](/images/tile-90s-step18.jpg)](/images/tile-90s-step18.jpg)<!-- {.example} -->
[![tile-90s-step19](/images/tile-90s-step19.jpg)](/images/tile-90s-step19.jpg)<!-- {.example} -->
[![tile-90s-step20](/images/tile-90s-step20.jpg)](/images/tile-90s-step20.jpg)<!-- {.example} -->
<!-- {p:.center} -->

</section>

<section>

# Buidling the Signs

TODO

</section>
