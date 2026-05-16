# Intro and Objectives

## Lesson Objectives

Learn what limit orders are - and specifically what take-profit orders are

Understand the mechanism design of how we can implement an order book through a hook

Partially build out the hook (with the rest in Part 2)

### Introduction

In this lesson, we're going to be looking at limit orders - and create an onchain order book directly integrated into Uniswap through a hook.

This is the first foray in this course where we start looking at ideas that have the potential to actually be big onchain businesses. While the hook we cover itself will not be fully production-ready - to respect the time and duration of this course - it will lay the foundation on which further improvements can be done to make something like this a reality.

Today, specifically, we're going to start working on a hook that is capable of executing "take-profit orders". So first, let's understand that a little bit.

A take-profit is a type of order where the user wants to sell a token once its price increases to a certain amount. For example, if ETH is currently trading at 3,500 USDC - I can place a take-profit order that would represent something like "Sell 1 ETH when it's trading at 4,000 USDC".

This will be a fairly long hook - more than we could cover in a single 90-minute workshop - so it's broken up into two parts for the live lectures. The two written lessons are divided up with one focusing on functionality around creating and canceling orders and writing the code to fulfill an order and its related tests - and part 2 is focused on writing the actual hook function which combines all those ideas, and writing tests for the full end-to-end flow. The live workshop breakup into two parts may be slightly different, depending on timing and questions.
