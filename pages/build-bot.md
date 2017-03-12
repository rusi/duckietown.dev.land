---
title: Build Duckiebot
path: /build/duckiebot/
---

<section>

# Building Duckiebot

In order to move around Duckietown, you need to have a Duckiebot. Building a Duckiebot is not
very difficult, but requires some soldering skills. Fell free to ask for help if you are having
trouble building the Duckiebot.

Duckiebot is built in four parts - Prep, Chassis, On-board Computer, and Accessories:
* **Prep - Soldering the Boards**. Some of the electronic boards have to be soldered. 
* **Chassis** - the Chassis has to be assembled before attaching the on-board computer.
* **On-board Computer** - Duckiebot is powered a Raspberry Pi with a Camera.
* **Accessories** - everybody learns to manually drive the Duckiebot by using a Controller. In addition, a number of accessories can be added to Duckiebot - from a simple Speaker and headlights, to turn signals and stop lights.

</section>

<section>

## Materials

Following is a list of materials required to build Duckiebot (~$240):

* <a target="_blank"  href="https://www.amazon.com/gp/product/B007R9U5CU/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B007R9U5CU&linkCode=as2&tag=duckietown-20&linkId=f1dfffa12d232cd4ed8bdf77025da97e"><img border="0" src="//ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&MarketPlace=US&ASIN=B007R9U5CU&ServiceVersion=20070822&ID=AsinImage&WS=1&Format=_SL250_&tag=duckietown-20" width="40"/> Magician Chassis</a><img src="//ir-na.amazon-adsystem.com/e/ir?t=duckietown-20&l=am2&o=1&a=B007R9U5CU" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />
* <a target="_blank"  href="https://www.amazon.com/gp/product/B00IJZJKK4/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B00IJZJKK4&linkCode=as2&tag=duckietown-20&linkId=b62b3cf707bdf585601baae342773142"><img border="0" src="//ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&MarketPlace=US&ASIN=B00IJZJKK4&ServiceVersion=20070822&ID=AsinImage&WS=1&Format=_SL250_&tag=duckietown-20" width="40"/> Raspberry Pi Camera Case for V2</a><img src="//ir-na.amazon-adsystem.com/e/ir?t=duckietown-20&l=am2&o=1&a=B00IJZJKK4" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />
* <a target="_blank"  href="https://www.amazon.com/gp/product/B01C6Q2GSY/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B01C6Q2GSY&linkCode=as2&tag=duckietown-20&linkId=3ecb440815454290baa1b1cfb075112d"><img border="0" src="//ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&MarketPlace=US&ASIN=B01C6Q2GSY&ServiceVersion=20070822&ID=AsinImage&WS=1&Format=_SL250_&tag=duckietown-20" width="40"/> CanaKit Raspberry Pi 3 Complete Starter Kit - 32 GB Edition</a><img src="//ir-na.amazon-adsystem.com/e/ir?t=duckietown-20&l=am2&o=1&a=B01C6Q2GSY" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />
* <a target="_blank"  href="https://www.amazon.com/gp/product/B01LH6SVEC/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B01LH6SVEC&linkCode=as2&tag=duckietown-20&linkId=d78c6878809e8c3e1027773ae0499edb"><img border="0" src="//ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&MarketPlace=US&ASIN=B01LH6SVEC&ServiceVersion=20070822&ID=AsinImage&WS=1&Format=_SL250_&tag=duckietown-20" width="40"/> SainSmart 5MP Fisheye (FOV160) Camera Module for Raspberry Pi 3 / Pi 2</a><img src="//ir-na.amazon-adsystem.com/e/ir?t=duckietown-20&l=am2&o=1&a=B01LH6SVEC" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />
* <a target="_blank"  href="https://www.amazon.com/gp/product/B00XW2N7HQ/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B00XW2N7HQ&linkCode=as2&tag=duckietown-20&linkId=a8eaef6650885e41567a0f29a2b9f8fa"><img border="0" src="//ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&MarketPlace=US&ASIN=B00XW2N7HQ&ServiceVersion=20070822&ID=AsinImage&WS=1&Format=_SL250_&tag=duckietown-20" width="40"/> Adafruit DC & Stepper Motor HAT for Raspberry Pi</a><img src="//ir-na.amazon-adsystem.com/e/ir?t=duckietown-20&l=am2&o=1&a=B00XW2N7HQ" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />
* <a target="_blank"  href="https://www.amazon.com/gp/product/B00SI1SPHS/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B00SI1SPHS&linkCode=as2&tag=duckietown-20&linkId=b754f4db9ebcf8a2931540998a687cca"><img border="0" src="//ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&MarketPlace=US&ASIN=B00SI1SPHS&ServiceVersion=20070822&ID=AsinImage&WS=1&Format=_SL250_&tag=duckietown-20" width="40"/> Adafruit 16-Channel PWM / Servo HAT for Raspberry Pi</a><img src="//ir-na.amazon-adsystem.com/e/ir?t=duckietown-20&l=am2&o=1&a=B00SI1SPHS" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />
* 2 x <a target="_blank"  href="https://www.amazon.com/gp/product/B00TW0W9HQ/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B00TW0W9HQ&linkCode=as2&tag=duckietown-20&linkId=7796449fa4f5d7e7f23b662f8dcd11bf"><img border="0" src="//ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&MarketPlace=US&ASIN=B00TW0W9HQ&ServiceVersion=20070822&ID=AsinImage&WS=1&Format=_SL250_&tag=duckietown-20" width="40"/> GPIO Stacking Header for Pi A+/B+/Pi 2 - Extra-long 2x20 Pins</a><img src="//ir-na.amazon-adsystem.com/e/ir?t=duckietown-20&l=am2&o=1&a=B00TW0W9HQ" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />
* <a target="_blank"  href="https://www.amazon.com/gp/product/B00XC1W9H6/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B00XC1W9H6&linkCode=as2&tag=duckietown-20&linkId=b7109f1efdbf78958eea340aeb2ccdca"><img border="0" src="//ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&MarketPlace=US&ASIN=B00XC1W9H6&ServiceVersion=20070822&ID=AsinImage&WS=1&Format=_SL250_&tag=duckietown-20" width="40"/> RAVPower Portable Charger 10400mAh External Batery Pack</a><img src="//ir-na.amazon-adsystem.com/e/ir?t=duckietown-20&l=am2&o=1&a=B00XC1W9H6" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />
* <a target="_blank"  href="https://www.amazon.com/gp/product/B009JXJITS/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B009JXJITS&linkCode=as2&tag=duckietown-20&linkId=7aa15a115835a73500044fb7658e402b"><img border="0" src="//ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&MarketPlace=US&ASIN=B009JXJITS&ServiceVersion=20070822&ID=AsinImage&WS=1&Format=_SL250_&tag=duckietown-20" width="40"/> USB A to Type N (5.5mm) Barrel 5V DC Power Cable(USB2TYPEN1M)</a><img src="//ir-na.amazon-adsystem.com/e/ir?t=duckietown-20&l=am2&o=1&a=B009JXJITS" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />
* <a target="_blank"  href="https://www.amazon.com/gp/product/B014J1ZLD6/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B014J1ZLD6&linkCode=as2&tag=duckietown-20&linkId=0375c51cd1ccec5331fd88ddcb5df3ba"><img border="0" src="//ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&MarketPlace=US&ASIN=B014J1ZLD6&ServiceVersion=20070822&ID=AsinImage&WS=1&Format=_SL250_&tag=duckietown-20" width="40"/> M2.5 Nylon Hex M-F Spacer/Screw/Nut Assorted Kit, Standoff</a><img src="//ir-na.amazon-adsystem.com/e/ir?t=duckietown-20&l=am2&o=1&a=B014J1ZLD6" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />
* <a target="_blank"  href="https://www.amazon.com/gp/product/B004C4ZNPW/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B004C4ZNPW&linkCode=as2&tag=duckietown-20&linkId=27944954143380ec1d87efc60c5a29ef"><img border="0" src="//ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&MarketPlace=US&ASIN=B004C4ZNPW&ServiceVersion=20070822&ID=AsinImage&WS=1&Format=_SL250_&tag=duckietown-20" height="40"/> Cable Zip Tie 8 inch</a><img src="//ir-na.amazon-adsystem.com/e/ir?t=duckietown-20&l=am2&o=1&a=B004C4ZNPW" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />

---
Additional Items (~$70):

* <a target="_blank"  href="https://www.amazon.com/gp/product/B0041RR0TW/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B0041RR0TW&linkCode=as2&tag=duckietown-20&linkId=cd280d9ff89e02899808e672ea695153"><img border="0" src="//ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&MarketPlace=US&ASIN=B0041RR0TW&ServiceVersion=20070822&ID=AsinImage&WS=1&Format=_SL250_&tag=duckietown-20" width="40"/> Logitech Gamepad F710</a><img src="//ir-na.amazon-adsystem.com/e/ir?t=duckietown-20&l=am2&o=1&a=B0041RR0TW" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />
* <a target="_blank"  href="https://www.amazon.com/gp/product/B00NLO9JB8/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B00NLO9JB8&linkCode=as2&tag=duckietown-20&linkId=3fadaddb295cfa347aaf0b75b8bdd718"><img border="0" src="//ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&MarketPlace=US&ASIN=B00NLO9JB8&ServiceVersion=20070822&ID=AsinImage&WS=1&Format=_SL250_&tag=duckietown-20" width="40"/> Quikcell Portable Speaker</a><img src="//ir-na.amazon-adsystem.com/e/ir?t=duckietown-20&l=am2&o=1&a=B00NLO9JB8" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />
* <a target="_blank"  href="https://www.amazon.com/gp/product/B0173QNVT0/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B0173QNVT0&linkCode=as2&tag=duckietown-20&linkId=5418bf458dfa62586ac0333bca14b509"><img border="0" src="//ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&MarketPlace=US&ASIN=B0173QNVT0&ServiceVersion=20070822&ID=AsinImage&WS=1&Format=_SL250_&tag=duckietown-20" width="40"/> JETech 2.4G Wireless Keyboard</a><img src="//ir-na.amazon-adsystem.com/e/ir?t=duckietown-20&l=am2&o=1&a=B0173QNVT0" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />
* <a target="_blank"  href="https://www.amazon.com/gp/product/B001DHECXA/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B001DHECXA&linkCode=as2&tag=duckietown-20&linkId=ab2191630ec8754b27bd8008062cba1e"><img border="0" src="//ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&MarketPlace=US&ASIN=B001DHECXA&ServiceVersion=20070822&ID=AsinImage&WS=1&Format=_SL250_&tag=duckietown-20" width="40"/> TeckNet 2.4G Nano Wireless Mouse, 5 Buttons (M002)</a><img src="//ir-na.amazon-adsystem.com/e/ir?t=duckietown-20&l=am2&o=1&a=B001DHECXA" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />

</section>

<section>

# 1. Soldering the Boards

We start by soldering the two boards needed to drive the motors.

</section>

<section>

# 2. Assembling the Chassis

Follow these steps to assemble the chassis.

</section>

<section>

# 3. The On-Board Computer

The Raspberri Pi sits on top of the chassis.

</section>

<section>

# 4. Additional Accessories

We start by **using the Controller**. Later we **add a Speaker**.

</section>


