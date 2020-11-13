import random

def match_probs(a1, a2, b1, b2):
    """Convert game probs into starting game match probs."""
    return (
        a1 * (1 - (1-b1) * (1-b2)) + (1-a1) * a2 * b2,
        a2 * (1 - (1-b1) * (1-b2)) + (1-a2) * a1 * b1,
        b1 * (1 - (1-a1) * (1-a2)) + (1-b1) * a2 * b2,
        b2 * (1 - (1-a1) * (1-a2)) + (1-b2) * a1 * b1
        )

def pick(a1, a2, b1, b2):
    """Given win probabilities for each pairing, return the probability
       with which I should choose 'a' over 'b'.
    """
    # I have a pure dominant strategy.
    if a1 >= b1 and a2 >= b2:
        p = 1
    elif b1 >= a1 and b2 >= a2:
        p = 0
    # Opponent has a pure dominant strategy.
    elif a1 <= a2 and b1 <= b2:
        p = 1 if a1 >= b1 else 0
    elif a2 <= a1 and b2 <= b1:
        p = 1 if a2 >= b2 else 0
    # Mixed strategy.
    else:
        p = (b2 - b1) / (a1 + b2 - a2 - b1)
    first = random.random() < p
    return p, first

def pick_and_win_prob(a1, a2, b1, b2):
    # Choose my strategy.
    p1 = pick(a1, a2, b1, b2)
    p1p = p1[0]
    print(f'player 1: {p1}')
    # Opponent chooses strategy.
    p2 = pick(1-a1, 1-b1, 1-a2, 1-b2)
    p2p = p2[0]
    print(f'player 2: {p2}')

    # Return my choice and match win probability.
    return (p1[1],
            p1p*p2p*a1 + p1p*(1-p2p)*a2 + (1-p1p)*p2p*b1 + (1-p1p)*(1-p2p)*b2)

def pick_and_win_prob_for_game_probs(game_probs):
    """Call with game probs, e.g. (0.5, 0.4, 0.6, 0.2)"""
    return pick_and_win_prob(*match_probs(*game_probs))
