## Gas Price Based Fees

### Objective

In this lesson, we're going to build our first Dynamic Fees hook.

#### Mechanism Design

The idea here is simple. We will design a hook that keeps track of the moving average gas price over time onchain. When gas price is roughly equal to the average, we will charge a certain amount of fees. If gas price is over 10% higher than the average, we will charge lower fees. If gas price is at least 10% lower than the average, we will charge higher fees.

To make this a production-level system, you probably want to do some simple financial modelling to make sure that users aren't intentionally setting a higher gas price because the reduced fee actually lowers their total cost below what it would've cost them if they just swapped at the average fees - but we won't worry about that too much right now and only focus on the concept of dynamic fees.

Our hook contract basically then just needs to do two things:

Keep track of the moving average gas price
For each swap, dynamically adjust the swap fees being charged
