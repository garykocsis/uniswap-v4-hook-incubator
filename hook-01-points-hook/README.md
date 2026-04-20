# Intro and Objectives

## Lesson Objectives

- Be able to set up a new Foundry project for building hooks
- Learn how to mine for proper hook addresses that meet the bitmap requirements
- Create a simple hook that issues ERC-1155 tokens as points for certain types of trades

## Introduction

in this lesson, we're finally going to start writing some code. We'll be building a simple points hook.

Imagine you have some memecoin-type coin called TOKEN. We want to attach our hook into ETH <> TOKEN pools. Our goal is to incentivize swappers to buy TOKEN in exchange for ETH. This incentivization happens through the hook issuing second POINTS tokens when desired actions occur. For simplicity, we'll set some basic rules and assumptions:

When a swap takes place which buys TOKEN for ETH - we will issue POINTS equivalent to 20% of the ETH amount swapped in to the user.
