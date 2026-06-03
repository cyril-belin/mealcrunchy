# Design Export Context

- Generated at: `2026-06-03T18:03:19.993Z`
- Document ID: `2d89fb7e-08e4-4009-bb7b-227528bd4591`
- Page count: 10

## Original Prompt

```text
Design a modern, friendly, and easy-to-use mobile Meal Planner app with onboarding and personalised meal planning.

Requirements:
- Splash Screen
- Login & Sign up Screens
- 8-10 onboarding screens asking user preferences (goals, diet type, allergies, activity level, meal timing, current weight, target weight, age, height)
- AI-generated meal plan overview screen showing daily meals for Breakfast, Lunch, Dinner, and Snacks
- Daily meal detail screen with:
  - Name
  - Calories
  - Macronutrients (protein, carbs, fat)
  - Quick recipe or instructions
- Progress indicator during onboarding
- Profile screen
- Preferences screen where he can see selections of onboarding and option to edit onboarding flow

- Friendly, modern look with soft colors (greens, whites, light neutrals)
- Rounded buttons and cards
- Clear, readable text and large icons
- Clean, simple, user-friendly flow that's easy for beginners

The design should feel modern, professional, and visually appealing, ready for conversion into a mobile app.
```

## Theme (JSON)

```json
{
  "shadows": {
    "xxl": {
      "dy": 20,
      "blur": 40,
      "dx": 0,
      "color": "#2D6A4F30",
      "spread": 0
    },
    "md": {
      "dy": 6,
      "blur": 12,
      "dx": 0,
      "color": "#2D6A4F1A",
      "spread": 0
    },
    "none": {
      "color": "#00000000",
      "spread": 0,
      "dx": 0,
      "blur": 0,
      "dy": 0
    },
    "lg": {
      "dy": 10,
      "blur": 20,
      "dx": 0,
      "color": "#2D6A4F20",
      "spread": 0
    },
    "xs": {
      "dx": 0,
      "color": "#2D6A4F10",
      "spread": 0,
      "dy": 2,
      "blur": 4
    },
    "sm": {
      "blur": 8,
      "dy": 4,
      "color": "#2D6A4F15",
      "spread": 0,
      "dx": 0
    },
    "xl": {
      "color": "#2D6A4F25",
      "spread": 0,
      "dx": 0,
      "blur": 30,
      "dy": 15
    }
  },
  "gradients": {},
  "text_styles": {
    "label_medium": {
      "weight": 700,
      "height": 1.2,
      "font": "primary",
      "size": 12
    },
    "display_small": {
      "size": 38,
      "font": "primary",
      "height": 1.2,
      "weight": 700
    },
    "display_large": {
      "height": 1.1,
      "font": "primary",
      "size": 58,
      "weight": 800
    },
    "display_medium": {
      "weight": 800,
      "height": 1.15,
      "font": "primary",
      "size": 46
    },
    "title_small": {
      "weight": 600,
      "size": 14,
      "font": "secondary",
      "height": 1.4
    },
    "headline_large": {
      "height": 1.2,
      "size": 32,
      "font": "primary",
      "weight": 700
    },
    "body_large": {
      "height": 1.6,
      "font": "secondary",
      "size": 16,
      "weight": 400
    },
    "headline_medium": {
      "weight": 600,
      "size": 26,
      "font": "primary",
      "height": 1.25
    },
    "headline_small": {
      "size": 24,
      "font": "primary",
      "height": 1.3,
      "weight": 600
    },
    "title_medium": {
      "font": "secondary",
      "size": 17,
      "height": 1.4,
      "weight": 600
    },
    "label_large": {
      "weight": 700,
      "height": 1.2,
      "size": 14,
      "font": "primary"
    },
    "body_small": {
      "height": 1.5,
      "font": "secondary",
      "size": 12,
      "weight": 400
    },
    "body_medium": {
      "weight": 400,
      "size": 14,
      "font": "secondary",
      "height": 1.5
    },
    "title_large": {
      "height": 1.3,
      "size": 22,
      "font": "secondary",
      "weight": 600
    },
    "label_small": {
      "weight": 700,
      "height": 1.2,
      "size": 10,
      "font": "primary"
    }
  },
  "fonts": {
    "primary": "google:Plus Jakarta Sans",
    "secondary": "google:Outfit",
    "mono": "google:Space Grotesk"
  },
  "colors": {
    "light": {
      "on_info": "#FFFFFF",
      "full_contrast": "#000000",
      "on_success": "#FFFFFF",
      "warning": "#F4A261",
      "on_accent": "#FFFFFF",
      "info": "#457B9D",
      "transparent": "#00000000",
      "divider": "#E9ECEF",
      "primary_text": "#1B4332",
      "surface": "#EBF2EE",
      "primary_container": "#2D6A4F1A",
      "on_surface_variant": "#556B5F",
      "accent": "#FF9F1C",
      "primary": "#2D6A4F",
      "on_secondary_container": "#1B4332",
      "secondary_text": "#556B5F",
      "error": "#E63946",
      "on_background": "#1B4332",
      "secondary": "#52B788",
      "hint": "#A3B18A",
      "background": "#F8FAF8",
      "surface_variant": "#D8E2DC",
      "on_error": "#FFFFFF",
      "secondary_container": "#52B7881A",
      "secondary_background": "#FFFFFF",
      "on_secondary": "#FFFFFF",
      "on_primary_container": "#1B4332",
      "on_accent_container": "#1B4332",
      "on_surface": "#1B4332",
      "accent_container": "#FF9F1C1A",
      "success": "#40916C",
      "on_warning": "#FFFFFF",
      "outline": "#CED4DA",
      "on_primary": "#FFFFFF"
    },
    "dark": {
      "on_accent_container": "#D8F3DC",
      "on_surface": "#D8F3DC",
      "on_primary_container": "#D8F3DC",
      "on_secondary": "#000000",
      "secondary_container": "#95D5B224",
      "on_error": "#FFFFFF",
      "secondary_background": "#1B4332",
      "background": "#081C15",
      "surface_variant": "#40916C",
      "on_primary": "#FFFFFF",
      "outline": "#52B788",
      "on_warning": "#000000",
      "success": "#95D5B2",
      "accent_container": "#FFBF6924",
      "divider": "#2D6A4F",
      "transparent": "#00000000",
      "on_accent": "#000000",
      "info": "#A8DADC",
      "warning": "#FFB703",
      "on_success": "#000000",
      "full_contrast": "#FFFFFF",
      "on_info": "#000000",
      "hint": "#95D5B2",
      "secondary": "#95D5B2",
      "on_background": "#D8F3DC",
      "error": "#FF4D6D",
      "secondary_text": "#B7E4C7",
      "primary": "#74C69D",
      "on_secondary_container": "#D8F3DC",
      "accent": "#FFBF69",
      "surface": "#2D6A4F",
      "primary_text": "#D8F3DC",
      "on_surface_variant": "#B7E4C7",
      "primary_container": "#74C69D24"
    }
  },
  "schema_version": 2,
  "spacing": {
    "md": 16,
    "xxl": 48,
    "xxxl": 64,
    "none": 0,
    "sm": 8,
    "xl": 32,
    "lg": 24,
    "xs": 4
  },
  "radii": {
    "md": 16,
    "xxl": 40,
    "sm": 10,
    "xl": 32,
    "lg": 24,
    "full": 9999,
    "xs": 6,
    "none": 0
  }
}
```

## Pages

### 1. Splash Screen

- Frame ID: `frame1`
- Original page prompt: "A clean splash screen with the app logo and a soft background"
- Follow-up prompts: _None_

#### DslDocument (JSON)

```json
{
  "root": {
    "type": "scaffold",
    "properties": {
      "bg": {
        "color": {
          "color": "background"
        }
      }
    },
    "children": [
      {
        "type": "stack",
        "children": [
          {
            "type": "container",
            "properties": {
              "width": {
                "px": {
                  "value": 300,
                  "isInfinity": false
                }
              },
              "height": {
                "px": {
                  "value": 300,
                  "isInfinity": false
                }
              },
              "radius": {
                "radius": {
                  "topLeft": 0,
                  "topRight": 0,
                  "bottomLeft": 0,
                  "bottomRight": 0,
                  "token": "full"
                }
              },
              "bg": {
                "color": {
                  "color": "success",
                  "opacityPercent": 10
                }
              },
              "align": {
                "align": {
                  "positional": {
                    "x": -1.2,
                    "y": -0.8
                  }
                }
              }
            },
            "editorId": "container18"
          },
          {
            "type": "container",
            "properties": {
              "width": {
                "px": {
                  "value": 400,
                  "isInfinity": false
                }
              },
              "height": {
                "px": {
                  "value": 400,
                  "isInfinity": false
                }
              },
              "radius": {
                "radius": {
                  "topLeft": 0,
                  "topRight": 0,
                  "bottomLeft": 0,
                  "bottomRight": 0,
                  "token": "full"
                }
              },
              "bg": {
                "color": {
                  "color": "primary",
                  "opacityPercent": 5
                }
              },
              "align": {
                "align": {
                  "positional": {
                    "x": 1.5,
                    "y": 1.2
                  }
                }
              }
            },
            "editorId": "container19"
          },
          {
            "type": "column",
            "properties": {
              "align": {
                "align": {
                  "named": "center"
                }
              },
              "spacing": {
                "stringVal": {
                  "value": "xl"
                }
              },
              "padding": {
                "edgeInsets": {
                  "top": 0,
                  "right": 0,
                  "bottom": 0,
                  "left": 0,
                  "token": "lg"
                }
              }
            },
            "children": [
              {
                "type": "column",
                "properties": {
                  "spacing": {
                    "stringVal": {
                      "value": "lg"
                    }
                  },
                  "align": {
                    "align": {
                      "named": "center"
                    }
                  }
                },
                "children": [
                  {
                    "type": "container",
                    "properties": {
                      "width": {
                        "px": {
                          "value": 120,
                          "isInfinity": false
                        }
                      },
                      "height": {
                        "px": {
                          "value": 120,
                          "isInfinity": false
                        }
                      },
                      "bg": {
                        "color": {
                          "color": "surface"
                        }
                      },
                      "radius": {
                        "radius": {
                          "topLeft": 40,
                          "topRight": 40,
                          "bottomLeft": 40,
                          "bottomRight": 40
                        }
                      },
                      "shadow": {
                        "stringVal": {
                          "value": "lg"
                        }
                      },
                      "align_child": {
                        "align": {
                          "named": "center"
                        }
                      }
                    },
                    "children": [
                      {
                        "type": "stack",
                        "children": [
                          {
                            "type": "icon",
                            "properties": {
                              "name": {
                                "icon": {
                                  "name": "eco_rounded"
                                }
                              },
                              "size": {
                                "numberVal": {
                                  "value": 64
                                }
                              },
                              "color": {
                                "color": {
                                  "color": "success"
                                }
                              }
                            },
                            "editorId": "icon11"
                          },
                          {
                            "type": "icon",
                            "properties": {
                              "name": {
                                "icon": {
                                  "name": "nutrition_rounded"
                                }
                              },
                              "size": {
                                "numberVal": {
                                  "value": 24
                                }
                              },
                              "color": {
                                "color": {
                                  "color": "success",
                                  "opacityPercent": 40
                                }
                              },
                              "align": {
                                "align": {
                                  "positional": {
                                    "x": 0.8,
                                    "y": 0.8
                                  }
                                }
                              }
                            },
                            "editorId": "icon12"
                          }
                        ],
                        "editorId": "stack2"
                      }
                    ],
                    "editorId": "container20"
                  },
                  {
                    "type": "column",
                    "properties": {
                      "spacing": {
                        "stringVal": {
                          "value": "xs"
                        }
                      },
                      "align": {
                        "align": {
                          "named": "center"
                        }
                      }
                    },
                    "children": [
                      {
                        "type": "text",
                        "properties": {
                          "content": {
                            "stringVal": {
                              "value": "NourishPath"
                            }
                          },
                          "style": {
                            "textStyle": {
                              "styleName": "headline_large"
                            }
                          },
                          "font_weight": {
                            "numberVal": {
                              "value": 800
                            }
                          },
                          "color": {
                            "color": {
                              "color": "primary_text"
                            }
                          }
                        },
                        "editorId": "text29"
                      },
                      {
                        "type": "text",
                        "properties": {
                          "content": {
                            "stringVal": {
                              "value": "Your AI-Powered Nutrition Guide"
                            }
                          },
                          "style": {
                            "textStyle": {
                              "styleName": "body_medium"
                            }
                          },
                          "color": {
                            "color": {
                              "color": "secondary_text"
                            }
                          },
                          "text_align": {
                            "align": {
                              "named": "center"
                            }
                          }
                        },
                        "editorId": "text30"
                      }
                    ],
                    "editorId": "column14"
                  }
                ],
                "editorId": "column13"
              },
              {
                "type": "column",
                "properties": {
                  "spacing": {
                    "stringVal": {
                      "value": "md"
                    }
                  },
                  "align": {
                    "align": {
                      "named": "center"
                    }
                  }
                },
                "children": [
                  {
                    "type": "lottie",
                    "properties": {
                      "source_desc": {
                        "imageSource": {
                          "type": "IMAGE_SOURCE_TYPE_URL",
                          "value": "https://dimg.dreamflow.cloud/v1/image/healthy+lifestyle+food+animation"
                        }
                      },
                      "width": {
                        "px": {
                          "value": 200,
                          "isInfinity": false
                        }
                      },
                      "height": {
                        "px": {
                          "value": 200,
                          "isInfinity": false
                        }
                      }
                    },
                    "editorId": "lottie1"
                  },
                  {
                    "type": "column",
                    "properties": {
                      "spacing": {
                        "stringVal": {
                          "value": "sm"
                        }
                      },
                      "align": {
                        "align": {
                          "named": "center"
                        }
                      }
                    },
                    "children": [
                      {
                        "type": "text",
                        "properties": {
                          "content": {
                            "stringVal": {
                              "value": "Personalizing your experience..."
                            }
                          },
                          "style": {
                            "textStyle": {
                              "styleName": "label_medium"
                            }
                          },
                          "color": {
                            "color": {
                              "color": "secondary_text"
                            }
                          }
                        },
                        "editorId": "text31"
                      },
                      {
                        "type": "container",
                        "properties": {
                          "width": {
                            "px": {
                              "value": 140,
                              "isInfinity": false
                            }
                          },
                          "height": {
                            "px": {
                              "value": 6,
                              "isInfinity": false
                            }
                          },
                          "bg": {
                            "color": {
                              "color": "surface_variant"
                            }
                          },
                          "radius": {
                            "radius": {
                              "topLeft": 0,
                              "topRight": 0,
                              "bottomLeft": 0,
                              "bottomRight": 0,
                              "token": "full"
                            }
                          },
                          "clip": {
                            "boolVal": {
                              "value": true
                            }
                          }
                        },
                        "children": [
                          {
                            "type": "container",
                            "properties": {
                              "width": {
                                "px": {
                                  "value": 60,
                                  "isInfinity": false
                                }
                              },
                              "height": {
                                "px": {
                                  "value": 6,
                                  "isInfinity": false
                                }
                              },
                              "bg": {
                                "color": {
                                  "color": "success"
                                }
                              },
                              "radius": {
                                "radius": {
                                  "topLeft": 0,
                                  "topRight": 0,
                                  "bottomLeft": 0,
                                  "bottomRight": 0,
                                  "token": "full"
                                }
                              },
                              "align": {
                                "align": {
                                  "positional": {
                                    "x": -1,
                                    "y": 0
                                  }
                                }
                              }
                            },
                            "editorId": "container22"
                          }
                        ],
                        "editorId": "container21"
                      }
                    ],
                    "editorId": "column16"
                  }
                ],
                "editorId": "column15"
              }
            ],
            "editorId": "column12"
          },
          {
            "type": "container",
            "properties": {
              "align": {
                "align": {
                  "named": "bottom_center"
                }
              },
              "padding": {
                "edgeInsets": {
                  "top": 0,
                  "right": 0,
                  "bottom": 0,
                  "left": 0,
                  "bottomToken": "xl"
                }
              }
            },
            "children": [
              {
                "type": "column",
                "properties": {
                  "spacing": {
                    "stringVal": {
                      "value": "xs"
                    }
                  },
                  "align": {
                    "align": {
                      "named": "center"
                    }
                  }
                },
                "children": [
                  {
                    "type": "text",
                    "properties": {
                      "content": {
                        "stringVal": {
                          "value": "Powered by AI Nutrition"
                        }
                      },
                      "style": {
                        "textStyle": {
                          "styleName": "label_small"
                        }
                      },
                      "color": {
                        "color": {
                          "color": "on_background"
                        }
                      }
                    },
                    "editorId": "text32"
                  },
                  {
                    "type": "row",
                    "properties": {
                      "spacing": {
                        "stringVal": {
                          "value": "sm"
                        }
                      },
                      "align": {
                        "align": {
                          "named": "center"
                        }
                      }
                    },
                    "children": [
                      {
                        "type": "icon",
                        "properties": {
                          "name": {
                            "icon": {
                              "name": "verified_user_rounded"
                            }
                          },
                          "size": {
                            "numberVal": {
                              "value": 14
                            }
                          },
                          "color": {
                            "color": {
                              "color": "success",
                              "opacityPercent": 50
                            }
                          }
                        },
                        "editorId": "icon13"
                      },
                      {
                        "type": "icon",
                        "properties": {
                          "name": {
                            "icon": {
                              "name": "psychology_rounded"
                            }
                          },
                          "size": {
                            "numberVal": {
                              "value": 14
                            }
                          },
                          "color": {
                            "color": {
                              "color": "success",
                              "opacityPercent": 50
                            }
                          }
                        },
                        "editorId": "icon14"
                      }
                    ],
                    "editorId": "row14"
                  }
                ],
                "editorId": "column17"
              }
            ],
            "editorId": "container23"
          }
        ],
        "editorId": "stack1"
      }
    ],
    "editorId": "scaffold1"
  }
}
```

### 2. Login & Sign Up

- Frame ID: `frame3`
- Original page prompt: "Login and signup page with social auth options and soft rounded inputs"
- Follow-up prompts: _None_

#### DslDocument (JSON)

```json
{
  "root": {
    "type": "scaffold",
    "properties": {
      "bg": {
        "color": {
          "color": "background"
        }
      },
      "safe_area": {
        "boolVal": {
          "value": true
        }
      }
    },
    "children": [
      {
        "type": "column",
        "properties": {
          "scroll": {
            "boolVal": {
              "value": true
            }
          },
          "padding": {
            "edgeInsets": {
              "top": 0,
              "right": 0,
              "bottom": 0,
              "left": 0,
              "token": "xl"
            }
          },
          "cross_align": {
            "align": {
              "named": "stretch"
            }
          }
        },
        "children": [
          {
            "type": "column",
            "properties": {
              "spacing": {
                "stringVal": {
                  "value": "md"
                }
              },
              "cross_align": {
                "align": {
                  "named": "center"
                }
              },
              "padding": {
                "edgeInsets": {
                  "top": 0,
                  "right": 0,
                  "bottom": 0,
                  "left": 0,
                  "bottomToken": "xl"
                }
              }
            },
            "children": [
              {
                "type": "container",
                "properties": {
                  "width": {
                    "px": {
                      "value": 80,
                      "isInfinity": false
                    }
                  },
                  "height": {
                    "px": {
                      "value": 80,
                      "isInfinity": false
                    }
                  },
                  "bg": {
                    "color": {
                      "color": "primary_container"
                    }
                  },
                  "radius": {
                    "radius": {
                      "topLeft": 24,
                      "topRight": 24,
                      "bottomLeft": 24,
                      "bottomRight": 24
                    }
                  },
                  "align_child": {
                    "align": {
                      "named": "center"
                    }
                  }
                },
                "children": [
                  {
                    "type": "icon",
                    "properties": {
                      "name": {
                        "icon": {
                          "name": "restaurant_menu_rounded"
                        }
                      },
                      "color": {
                        "color": {
                          "color": "on_primary"
                        }
                      },
                      "size": {
                        "numberVal": {
                          "value": 40
                        }
                      }
                    },
                    "editorId": "icon15"
                  }
                ],
                "editorId": "container24"
              },
              {
                "type": "text",
                "properties": {
                  "content": {
                    "stringVal": {
                      "value": "NourishPath"
                    }
                  },
                  "style": {
                    "textStyle": {
                      "styleName": "headline_medium"
                    }
                  },
                  "font_weight": {
                    "stringVal": {
                      "value": "bold"
                    }
                  },
                  "color": {
                    "color": {
                      "color": "primary"
                    }
                  }
                },
                "editorId": "text33"
              },
              {
                "type": "text",
                "properties": {
                  "content": {
                    "stringVal": {
                      "value": "Your personalized AI nutrition guide"
                    }
                  },
                  "style": {
                    "textStyle": {
                      "styleName": "body_medium"
                    }
                  },
                  "color": {
                    "color": {
                      "color": "secondary_text"
                    }
                  },
                  "text_align": {
                    "align": {
                      "named": "center"
                    }
                  }
                },
                "editorId": "text34"
              }
            ],
            "editorId": "column19"
          },
          {
            "type": "container",
            "properties": {
              "margin": {
                "edgeInsets": {
                  "top": 0,
                  "right": 0,
                  "bottom": 0,
                  "left": 0,
                  "bottomToken": "xl"
                }
              }
            },
            "children": [
              {
                "type": "@std.tab_group",
                "properties": {
                  "label_1": {
                    "stringVal": {
                      "value": "Login"
                    }
                  },
                  "label_2": {
                    "stringVal": {
                      "value": "Sign Up"
                    }
                  }
                },
                "editorId": "tabgroup1"
              }
            ],
            "editorId": "container25"
          },
          {
            "type": "column",
            "properties": {
              "spacing": {
                "stringVal": {
                  "value": "lg"
                }
              }
            },
            "children": [
              {
                "type": "column",
                "properties": {
                  "spacing": {
                    "stringVal": {
                      "value": "xs"
                    }
                  },
                  "cross_align": {
                    "align": {
                      "named": "start"
                    }
                  }
                },
                "children": [
                  {
                    "type": "text",
                    "properties": {
                      "content": {
                        "stringVal": {
                          "value": "Email Address"
                        }
                      },
                      "style": {
                        "textStyle": {
                          "styleName": "label_large"
                        }
                      },
                      "color": {
                        "color": {
                          "color": "primary_text"
                        }
                      }
                    },
                    "editorId": "text35"
                  },
                  {
                    "type": "@std.textfield",
                    "properties": {
                      "label": {
                        "stringVal": {
                          "value": "Email"
                        }
                      },
                      "hint": {
                        "stringVal": {
                          "value": "hello@example.com"
                        }
                      },
                      "leading_icon": {
                        "stringVal": {
                          "value": "mail_outline_rounded"
                        }
                      }
                    },
                    "editorId": "stdtextfield1"
                  }
                ],
                "editorId": "column21"
              },
              {
                "type": "column",
                "properties": {
                  "spacing": {
                    "stringVal": {
                      "value": "xs"
                    }
                  },
                  "cross_align": {
                    "align": {
                      "named": "start"
                    }
                  }
                },
                "children": [
                  {
                    "type": "text",
                    "properties": {
                      "content": {
                        "stringVal": {
                          "value": "Password"
                        }
                      },
                      "style": {
                        "textStyle": {
                          "styleName": "label_large"
                        }
                      },
                      "color": {
                        "color": {
                          "color": "primary_text"
                        }
                      }
                    },
                    "editorId": "text36"
                  },
                  {
                    "type": "@std.textfield",
                    "properties": {
                      "label": {
                        "stringVal": {
                          "value": "Password"
                        }
                      },
                      "hint": {
                        "stringVal": {
                          "value": "••••••••"
                        }
                      },
                      "leading_icon": {
                        "stringVal": {
                          "value": "lock_outline_rounded"
                        }
                      },
                      "trailing_icon": {
                        "stringVal": {
                          "value": "visibility_off_rounded"
                        }
                      }
                    },
                    "editorId": "textfield2"
                  }
                ],
                "editorId": "column22"
              },
              {
                "type": "row",
                "properties": {
                  "align": {
                    "align": {
                      "named": "end"
                    }
                  }
                },
                "children": [
                  {
                    "type": "@std.button",
                    "properties": {
                      "content": {
                        "stringVal": {
                          "value": "Forgot Password?"
                        }
                      },
                      "variant": {
                        "stringVal": {
                          "value": "ghost"
                        }
                      },
                      "size": {
                        "stringVal": {
                          "value": "small"
                        }
                      }
                    },
                    "editorId": "button1"
                  }
                ],
                "editorId": "row15"
              },
              {
                "type": "@std.button",
                "properties": {
                  "content": {
                    "stringVal": {
                      "value": "Sign In"
                    }
                  },
                  "variant": {
                    "stringVal": {
                      "value": "primary"
                    }
                  },
                  "size": {
                    "stringVal": {
                      "value": "large"
                    }
                  },
                  "full_width": {
                    "boolVal": {
                      "value": true
                    }
                  }
                },
                "editorId": "button2"
              }
            ],
            "editorId": "column20"
          },
          {
            "type": "row",
            "properties": {
              "spacing": {
                "stringVal": {
                  "value": "md"
                }
              },
              "padding": {
                "edgeInsets": {
                  "top": 0,
                  "right": 0,
                  "bottom": 0,
                  "left": 0,
                  "topToken": "xl",
                  "bottomToken": "xl"
                }
              }
            },
            "children": [
              {
                "type": "expanded",
                "children": [
                  {
                    "type": "divider",
                    "properties": {
                      "color": {
                        "color": {
                          "color": "divider"
                        }
                      }
                    },
                    "editorId": "d1"
                  }
                ],
                "editorId": "div1"
              },
              {
                "type": "text",
                "properties": {
                  "content": {
                    "stringVal": {
                      "value": "or"
                    }
                  },
                  "style": {
                    "textStyle": {
                      "styleName": "label_medium"
                    }
                  },
                  "color": {
                    "color": {
                      "color": "on_background"
                    }
                  }
                },
                "editorId": "text37"
              },
              {
                "type": "expanded",
                "children": [
                  {
                    "type": "divider",
                    "properties": {
                      "color": {
                        "color": {
                          "color": "divider"
                        }
                      }
                    },
                    "editorId": "d2"
                  }
                ],
                "editorId": "div2"
              }
            ],
            "editorId": "row16"
          },
          {
            "type": "column",
            "properties": {
              "cross_align": {
                "align": {
                  "named": "stretch"
                }
              }
            },
            "children": [
              {
                "type": "@social_button",
                "properties": {
                  "logo": {
                    "stringVal": {
                      "value": "google"
                    }
                  },
                  "label": {
                    "stringVal": {
                      "value": "Google"
                    }
                  }
                },
                "editorId": "socialbutton1"
              },
              {
                "type": "@social_button",
                "properties": {
                  "logo": {
                    "stringVal": {
                      "value": "apple"
                    }
                  },
                  "label": {
                    "stringVal": {
                      "value": "Apple"
                    }
                  }
                },
                "editorId": "socialbutton2"
              },
              {
                "type": "@social_button",
                "properties": {
                  "logo": {
                    "stringVal": {
                      "value": "facebook"
                    }
                  },
                  "label": {
                    "stringVal": {
                      "value": "Facebook"
                    }
                  }
                },
                "editorId": "socialbutton3"
              }
            ],
            "editorId": "column23"
          },
          {
            "type": "sizedbox",
            "properties": {
              "height": {
                "stringVal": {
                  "value": "xl"
                }
              }
            },
            "editorId": "sizedbox1"
          },
          {
            "type": "row",
            "properties": {
              "align": {
                "align": {
                  "named": "center"
                }
              },
              "spacing": {
                "stringVal": {
                  "value": "xs"
                }
              }
            },
            "children": [
              {
                "type": "text",
                "properties": {
                  "content": {
                    "stringVal": {
                      "value": "New to NourishPath?"
                    }
                  },
                  "style": {
                    "textStyle": {
                      "styleName": "body_medium"
                    }
                  },
                  "color": {
                    "color": {
                      "color": "secondary_text"
                    }
                  }
                },
                "editorId": "text38"
              },
              {
                "type": "@std.button",
                "properties": {
                  "content": {
                    "stringVal": {
                      "value": "Create Account"
                    }
                  },
                  "variant": {
                    "stringVal": {
                      "value": "ghost"
                    }
                  },
                  "size": {
                    "stringVal": {
                      "value": "medium"
                    }
                  }
                },
                "editorId": "button3"
              }
            ],
            "editorId": "row17"
          }
        ],
        "editorId": "column18"
      }
    ],
    "editorId": "scaffold2"
  }
}
```

### 3. Onboarding Goals

- Frame ID: `frame7`
- Original page prompt: "Onboarding screen for selecting primary health goals and diet types with a progress bar"
- Follow-up prompts: _None_

#### DslDocument (JSON)

```json
{
  "root": {
    "type": "scaffold",
    "properties": {
      "bg": {
        "color": {
          "color": "background"
        }
      },
      "safe_area": {
        "boolVal": {
          "value": true
        }
      }
    },
    "children": [
      {
        "type": "column",
        "properties": {
          "scroll": {
            "boolVal": {
              "value": true
            }
          },
          "padding": {
            "edgeInsets": {
              "top": 24,
              "right": 24,
              "bottom": 24,
              "left": 24
            }
          },
          "cross_align": {
            "align": {
              "named": "stretch"
            }
          }
        },
        "children": [
          {
            "type": "row",
            "properties": {
              "spacing": {
                "stringVal": {
                  "value": "md"
                }
              },
              "align": {
                "align": {
                  "named": "space_between"
                }
              }
            },
            "children": [
              {
                "type": "iconbutton",
                "properties": {
                  "name": {
                    "icon": {
                      "name": "arrow_back_rounded"
                    }
                  },
                  "color": {
                    "color": {
                      "color": "primary_text"
                    }
                  }
                },
                "editorId": "iconbutton2"
              },
              {
                "type": "expanded",
                "children": [
                  {
                    "type": "column",
                    "properties": {
                      "spacing": {
                        "stringVal": {
                          "value": "xs"
                        }
                      }
                    },
                    "children": [
                      {
                        "type": "progress",
                        "properties": {
                          "value": {
                            "numberVal": {
                              "value": 0.2
                            }
                          },
                          "color": {
                            "color": {
                              "color": "primary"
                            }
                          },
                          "bg_color": {
                            "color": {
                              "color": "divider"
                            }
                          },
                          "thickness": {
                            "numberVal": {
                              "value": 8
                            }
                          },
                          "radius": {
                            "radius": {
                              "topLeft": 0,
                              "topRight": 0,
                              "bottomLeft": 0,
                              "bottomRight": 0,
                              "token": "full"
                            }
                          }
                        },
                        "editorId": "progress1"
                      },
                      {
                        "type": "text",
                        "properties": {
                          "content": {
                            "stringVal": {
                              "value": "Step 2 of 10"
                            }
                          },
                          "style": {
                            "textStyle": {
                              "styleName": "label_small"
                            }
                          },
                          "color": {
                            "color": {
                              "color": "secondary_text"
                            }
                          },
                          "align": {
                            "align": {
                              "named": "center"
                            }
                          }
                        },
                        "editorId": "text39"
                      }
                    ],
                    "editorId": "column25"
                  }
                ],
                "editorId": "expanded7"
              },
              {
                "type": "sizedbox",
                "properties": {
                  "width": {
                    "px": {
                      "value": 40,
                      "isInfinity": false
                    }
                  }
                },
                "editorId": "sizedbox2"
              }
            ],
            "editorId": "row18"
          },
          {
            "type": "sizedbox",
            "properties": {
              "height": {
                "px": {
                  "value": 32,
                  "isInfinity": false
                }
              }
            },
            "editorId": "sizedbox3"
          },
          {
            "type": "column",
            "properties": {
              "spacing": {
                "stringVal": {
                  "value": "sm"
                }
              },
              "cross_align": {
                "align": {
                  "named": "start"
                }
              }
            },
            "children": [
              {
                "type": "text",
                "properties": {
                  "content": {
                    "stringVal": {
                      "value": "What's your goal?"
                    }
                  },
                  "style": {
                    "textStyle": {
                      "styleName": "headline_medium"
                    }
                  },
                  "font_weight": {
                    "numberVal": {
                      "value": 800
                    }
                  },
                  "color": {
                    "color": {
                      "color": "primary_text"
                    }
                  }
                },
                "editorId": "text40"
              },
              {
                "type": "text",
                "properties": {
                  "content": {
                    "stringVal": {
                      "value": "Select the primary health objective you'd like to reach with NourishPath."
                    }
                  },
                  "style": {
                    "textStyle": {
                      "styleName": "body_large"
                    }
                  },
                  "color": {
                    "color": {
                      "color": "secondary_text"
                    }
                  }
                },
                "editorId": "text41"
              }
            ],
            "editorId": "column26"
          },
          {
            "type": "sizedbox",
            "properties": {
              "height": {
                "px": {
                  "value": 24,
                  "isInfinity": false
                }
              }
            },
            "editorId": "sizedbox4"
          },
          {
            "type": "column",
            "properties": {
              "spacing": {
                "stringVal": {
                  "value": "none"
                }
              }
            },
            "children": [
              {
                "type": "@goal_option",
                "properties": {
                  "icon": {
                    "stringVal": {
                      "value": "fitness_center_rounded"
                    }
                  },
                  "title": {
                    "stringVal": {
                      "value": "Lose Weight"
                    }
                  },
                  "subtitle": {
                    "stringVal": {
                      "value": "Burn fat and get leaner with calorie-controlled plans"
                    }
                  },
                  "selected": {
                    "boolVal": {
                      "value": true
                    }
                  }
                },
                "editorId": "goal1"
              },
              {
                "type": "@goal_option",
                "properties": {
                  "icon": {
                    "stringVal": {
                      "value": "restaurant_rounded"
                    }
                  },
                  "title": {
                    "stringVal": {
                      "value": "Eat Healthier"
                    }
                  },
                  "subtitle": {
                    "stringVal": {
                      "value": "Improve your nutrition and develop better eating habits"
                    }
                  },
                  "selected": {
                    "boolVal": {
                      "value": false
                    }
                  }
                },
                "editorId": "goal2"
              },
              {
                "type": "@goal_option",
                "properties": {
                  "icon": {
                    "stringVal": {
                      "value": "bolt_rounded"
                    }
                  },
                  "title": {
                    "stringVal": {
                      "value": "Gain Muscle"
                    }
                  },
                  "subtitle": {
                    "stringVal": {
                      "value": "High protein meals designed for strength and mass"
                    }
                  },
                  "selected": {
                    "boolVal": {
                      "value": false
                    }
                  }
                },
                "editorId": "goal3"
              },
              {
                "type": "@goal_option",
                "properties": {
                  "icon": {
                    "stringVal": {
                      "value": "self_improvement_rounded"
                    }
                  },
                  "title": {
                    "stringVal": {
                      "value": "Maintain"
                    }
                  },
                  "subtitle": {
                    "stringVal": {
                      "value": "Keep your current weight while eating balanced meals"
                    }
                  },
                  "selected": {
                    "boolVal": {
                      "value": false
                    }
                  }
                },
                "editorId": "goal4"
              }
            ],
            "editorId": "column27"
          },
          {
            "type": "sizedbox",
            "properties": {
              "height": {
                "px": {
                  "value": 32,
                  "isInfinity": false
                }
              }
            },
            "editorId": "sizedbox5"
          },
          {
            "type": "column",
            "properties": {
              "spacing": {
                "stringVal": {
                  "value": "md"
                }
              },
              "cross_align": {
                "align": {
                  "named": "start"
                }
              }
            },
            "children": [
              {
                "type": "column",
                "properties": {
                  "spacing": {
                    "stringVal": {
                      "value": "xs"
                    }
                  },
                  "cross_align": {
                    "align": {
                      "named": "start"
                    }
                  }
                },
                "children": [
                  {
                    "type": "text",
                    "properties": {
                      "content": {
                        "stringVal": {
                          "value": "Dietary Preference"
                        }
                      },
                      "style": {
                        "textStyle": {
                          "styleName": "title_large"
                        }
                      },
                      "font_weight": {
                        "stringVal": {
                          "value": "bold"
                        }
                      },
                      "color": {
                        "color": {
                          "color": "primary_text"
                        }
                      }
                    },
                    "editorId": "text42"
                  },
                  {
                    "type": "text",
                    "properties": {
                      "content": {
                        "stringVal": {
                          "value": "Do you follow a specific diet style?"
                        }
                      },
                      "style": {
                        "textStyle": {
                          "styleName": "body_medium"
                        }
                      },
                      "color": {
                        "color": {
                          "color": "secondary_text"
                        }
                      }
                    },
                    "editorId": "text43"
                  }
                ],
                "editorId": "column29"
              },
              {
                "type": "wrap",
                "properties": {
                  "spacing": {
                    "stringVal": {
                      "value": "md"
                    }
                  },
                  "run_spacing": {
                    "stringVal": {
                      "value": "md"
                    }
                  }
                },
                "children": [
                  {
                    "type": "@diet_chip",
                    "properties": {
                      "icon": {
                        "stringVal": {
                          "value": "eco_rounded"
                        }
                      },
                      "label": {
                        "stringVal": {
                          "value": "Vegan"
                        }
                      },
                      "selected": {
                        "boolVal": {
                          "value": false
                        }
                      }
                    },
                    "editorId": "diet1"
                  },
                  {
                    "type": "@diet_chip",
                    "properties": {
                      "icon": {
                        "stringVal": {
                          "value": "set_meal_rounded"
                        }
                      },
                      "label": {
                        "stringVal": {
                          "value": "Keto"
                        }
                      },
                      "selected": {
                        "boolVal": {
                          "value": true
                        }
                      }
                    },
                    "editorId": "diet2"
                  },
                  {
                    "type": "@diet_chip",
                    "properties": {
                      "icon": {
                        "stringVal": {
                          "value": "egg_alt_rounded"
                        }
                      },
                      "label": {
                        "stringVal": {
                          "value": "Vegetarian"
                        }
                      },
                      "selected": {
                        "boolVal": {
                          "value": false
                        }
                      }
                    },
                    "editorId": "diet3"
                  },
                  {
                    "type": "@diet_chip",
                    "properties": {
                      "icon": {
                        "stringVal": {
                          "value": "grain_rounded"
                        }
                      },
                      "label": {
                        "stringVal": {
                          "value": "Paleo"
                        }
                      },
                      "selected": {
                        "boolVal": {
                          "value": false
                        }
                      }
                    },
                    "editorId": "diet4"
                  },
                  {
                    "type": "@diet_chip",
                    "properties": {
                      "icon": {
                        "stringVal": {
                          "value": "bakery_dining_rounded"
                        }
                      },
                      "label": {
                        "stringVal": {
                          "value": "Gluten-Free"
                        }
                      },
                      "selected": {
                        "boolVal": {
                          "value": false
                        }
                      }
                    },
                    "editorId": "diet5"
                  },
                  {
                    "type": "@diet_chip",
                    "properties": {
                      "icon": {
                        "stringVal": {
                          "value": "public_rounded"
                        }
                      },
                      "label": {
                        "stringVal": {
                          "value": "Mediterranean"
                        }
                      },
                      "selected": {
                        "boolVal": {
                          "value": false
                        }
                      }
                    },
                    "editorId": "diet6"
                  }
                ],
                "editorId": "wrap1"
              }
            ],
            "editorId": "column28"
          },
          {
            "type": "sizedbox",
            "properties": {
              "height": {
                "px": {
                  "value": 48,
                  "isInfinity": false
                }
              }
            },
            "editorId": "sizedbox6"
          },
          {
            "type": "@std.button",
            "properties": {
              "content": {
                "stringVal": {
                  "value": "Continue"
                }
              },
              "variant": {
                "stringVal": {
                  "value": "primary"
                }
              },
              "size": {
                "stringVal": {
                  "value": "large"
                }
              },
              "full_width": {
                "boolVal": {
                  "value": true
                }
              },
              "icon_end": {
                "stringVal": {
                  "value": "arrow_forward_rounded"
                }
              }
            },
            "editorId": "stdbutton1"
          },
          {
            "type": "sizedbox",
            "properties": {
              "height": {
                "px": {
                  "value": 16,
                  "isInfinity": false
                }
              }
            },
            "editorId": "sizedbox7"
          },
          {
            "type": "container",
            "properties": {
              "align_child": {
                "align": {
                  "named": "center"
                }
              }
            },
            "children": [
              {
                "type": "text",
                "properties": {
                  "content": {
                    "stringVal": {
                      "value": "I'll set this up later"
                    }
                  },
                  "style": {
                    "textStyle": {
                      "styleName": "label_large"
                    }
                  },
                  "color": {
                    "color": {
                      "color": "secondary_text"
                    }
                  },
                  "decoration": {
                    "stringVal": {
                      "value": "underline"
                    }
                  }
                },
                "editorId": "text44"
              }
            ],
            "editorId": "container26"
          }
        ],
        "editorId": "column24"
      }
    ],
    "editorId": "scaffold3"
  }
}
```

### 4. Onboarding Allergies

- Frame ID: `frame2`
- Original page prompt: "Onboarding screen for selecting allergies and food dislikes with large icons"
- Follow-up prompts: _None_

#### DslDocument (JSON)

```json
{
  "root": {
    "type": "scaffold",
    "properties": {
      "bg": {
        "color": {
          "color": "background"
        }
      },
      "safe_area": {
        "boolVal": {
          "value": true
        }
      }
    },
    "children": [
      {
        "type": "column",
        "properties": {
          "scroll": {
            "boolVal": {
              "value": true
            }
          },
          "cross_align": {
            "align": {
              "named": "stretch"
            }
          }
        },
        "children": [
          {
            "type": "container",
            "properties": {
              "padding": {
                "edgeInsets": {
                  "top": 0,
                  "right": 0,
                  "bottom": 0,
                  "left": 0,
                  "token": "lg"
                }
              },
              "bg": {
                "color": {
                  "color": "background"
                }
              }
            },
            "children": [
              {
                "type": "column",
                "properties": {
                  "spacing": {
                    "stringVal": {
                      "value": "md"
                    }
                  }
                },
                "children": [
                  {
                    "type": "row",
                    "properties": {
                      "align": {
                        "align": {
                          "named": "space_between"
                        }
                      }
                    },
                    "children": [
                      {
                        "type": "iconbutton",
                        "properties": {
                          "name": {
                            "icon": {
                              "name": "arrow_back_rounded"
                            }
                          },
                          "color": {
                            "color": {
                              "color": "primary_text"
                            }
                          }
                        },
                        "editorId": "iconbutton3"
                      },
                      {
                        "type": "text",
                        "properties": {
                          "content": {
                            "stringVal": {
                              "value": "Step 3 of 10"
                            }
                          },
                          "style": {
                            "textStyle": {
                              "styleName": "label_large"
                            }
                          },
                          "color": {
                            "color": {
                              "color": "secondary_text"
                            }
                          }
                        },
                        "editorId": "text45"
                      },
                      {
                        "type": "@std.button",
                        "properties": {
                          "content": {
                            "stringVal": {
                              "value": "Skip"
                            }
                          },
                          "variant": {
                            "stringVal": {
                              "value": "ghost"
                            }
                          },
                          "size": {
                            "stringVal": {
                              "value": "small"
                            }
                          }
                        },
                        "editorId": "stdbutton2"
                      }
                    ],
                    "editorId": "row19"
                  },
                  {
                    "type": "container",
                    "properties": {
                      "height": {
                        "px": {
                          "value": 8,
                          "isInfinity": false
                        }
                      },
                      "bg": {
                        "color": {
                          "color": "surface_variant"
                        }
                      },
                      "radius": {
                        "radius": {
                          "topLeft": 0,
                          "topRight": 0,
                          "bottomLeft": 0,
                          "bottomRight": 0,
                          "token": "full"
                        }
                      }
                    },
                    "children": [
                      {
                        "type": "container",
                        "properties": {
                          "width": {
                            "percent": {
                              "value": 30
                            }
                          },
                          "height": {
                            "px": {
                              "value": 8,
                              "isInfinity": false
                            }
                          },
                          "bg": {
                            "color": {
                              "color": "primary"
                            }
                          },
                          "radius": {
                            "radius": {
                              "topLeft": 0,
                              "topRight": 0,
                              "bottomLeft": 0,
                              "bottomRight": 0,
                              "token": "full"
                            }
                          },
                          "align": {
                            "align": {
                              "positional": {
                                "x": -1,
                                "y": 0
                              }
                            }
                          }
                        },
                        "editorId": "container29"
                      }
                    ],
                    "editorId": "container28"
                  }
                ],
                "editorId": "column31"
              }
            ],
            "editorId": "container27"
          },
          {
            "type": "column",
            "properties": {
              "padding": {
                "edgeInsets": {
                  "top": 0,
                  "right": 0,
                  "bottom": 0,
                  "left": 0,
                  "topToken": "lg",
                  "bottomToken": "lg"
                }
              },
              "spacing": {
                "stringVal": {
                  "value": "sm"
                }
              },
              "cross_align": {
                "align": {
                  "named": "center"
                }
              }
            },
            "children": [
              {
                "type": "text",
                "properties": {
                  "content": {
                    "stringVal": {
                      "value": "Any allergies or dislikes?"
                    }
                  },
                  "style": {
                    "textStyle": {
                      "styleName": "headline_medium"
                    }
                  },
                  "font_weight": {
                    "numberVal": {
                      "value": 800
                    }
                  },
                  "color": {
                    "color": {
                      "color": "primary_text"
                    }
                  }
                },
                "editorId": "text46"
              },
              {
                "type": "text",
                "properties": {
                  "content": {
                    "stringVal": {
                      "value": "We'll exclude these from your meal plans"
                    }
                  },
                  "style": {
                    "textStyle": {
                      "styleName": "body_medium"
                    }
                  },
                  "color": {
                    "color": {
                      "color": "secondary_text"
                    }
                  }
                },
                "editorId": "text47"
              }
            ],
            "editorId": "column32"
          },
          {
            "type": "grid",
            "properties": {
              "columns": {
                "numberVal": {
                  "value": 2
                }
              },
              "spacing": {
                "stringVal": {
                  "value": "lg"
                }
              },
              "padding": {
                "edgeInsets": {
                  "top": 0,
                  "right": 0,
                  "bottom": 0,
                  "left": 0,
                  "token": "lg"
                }
              },
              "aspect_ratio": {
                "numberVal": {
                  "value": 0.85
                }
              },
              "shrink_wrap": {
                "boolVal": {
                  "value": true
                }
              }
            },
            "children": [
              {
                "type": "@allergy_card",
                "properties": {
                  "icon": {
                    "stringVal": {
                      "value": "ice_cream_rounded"
                    }
                  },
                  "label": {
                    "stringVal": {
                      "value": "Dairy"
                    }
                  },
                  "description": {
                    "stringVal": {
                      "value": "Milk, cheese, yogurt"
                    }
                  },
                  "selected": {
                    "boolVal": {
                      "value": true
                    }
                  }
                },
                "editorId": "allergycard1"
              },
              {
                "type": "@allergy_card",
                "properties": {
                  "icon": {
                    "stringVal": {
                      "value": "nutrition_rounded"
                    }
                  },
                  "label": {
                    "stringVal": {
                      "value": "Peanuts"
                    }
                  },
                  "description": {
                    "stringVal": {
                      "value": "Peanut butter, oils"
                    }
                  },
                  "selected": {
                    "boolVal": {
                      "value": false
                    }
                  }
                },
                "editorId": "allergycard2"
              },
              {
                "type": "@allergy_card",
                "properties": {
                  "icon": {
                    "stringVal": {
                      "value": "grain_rounded"
                    }
                  },
                  "label": {
                    "stringVal": {
                      "value": "Gluten"
                    }
                  },
                  "description": {
                    "stringVal": {
                      "value": "Wheat, rye, barley"
                    }
                  },
                  "selected": {
                    "boolVal": {
                      "value": false
                    }
                  }
                },
                "editorId": "allergycard3"
              },
              {
                "type": "@allergy_card",
                "properties": {
                  "icon": {
                    "stringVal": {
                      "value": "set_meal_rounded"
                    }
                  },
                  "label": {
                    "stringVal": {
                      "value": "Seafood"
                    }
                  },
                  "description": {
                    "stringVal": {
                      "value": "Fish and shellfish"
                    }
                  },
                  "selected": {
                    "boolVal": {
                      "value": false
                    }
                  }
                },
                "editorId": "allergycard4"
              },
              {
                "type": "@allergy_card",
                "properties": {
                  "icon": {
                    "stringVal": {
                      "value": "egg_rounded"
                    }
                  },
                  "label": {
                    "stringVal": {
                      "value": "Eggs"
                    }
                  },
                  "description": {
                    "stringVal": {
                      "value": "Whole eggs, mayo"
                    }
                  },
                  "selected": {
                    "boolVal": {
                      "value": false
                    }
                  }
                },
                "editorId": "allergycard5"
              },
              {
                "type": "@allergy_card",
                "properties": {
                  "icon": {
                    "stringVal": {
                      "value": "eco_rounded"
                    }
                  },
                  "label": {
                    "stringVal": {
                      "value": "Soy"
                    }
                  },
                  "description": {
                    "stringVal": {
                      "value": "Tofu, soy sauce"
                    }
                  },
                  "selected": {
                    "boolVal": {
                      "value": false
                    }
                  }
                },
                "editorId": "allergycard6"
              }
            ],
            "editorId": "grid1"
          },
          {
            "type": "column",
            "properties": {
              "padding": {
                "edgeInsets": {
                  "top": 0,
                  "right": 0,
                  "bottom": 0,
                  "left": 0,
                  "token": "lg"
                }
              },
              "spacing": {
                "stringVal": {
                  "value": "md"
                }
              }
            },
            "children": [
              {
                "type": "text",
                "properties": {
                  "content": {
                    "stringVal": {
                      "value": "Other dislikes"
                    }
                  },
                  "style": {
                    "textStyle": {
                      "styleName": "title_small"
                    }
                  },
                  "color": {
                    "color": {
                      "color": "primary_text"
                    }
                  }
                },
                "editorId": "text48"
              },
              {
                "type": "@std.textfield",
                "properties": {
                  "hint": {
                    "stringVal": {
                      "value": "e.g. Cilantro, Mushrooms..."
                    }
                  },
                  "leading_icon": {
                    "stringVal": {
                      "value": "search_rounded"
                    }
                  },
                  "variant": {
                    "stringVal": {
                      "value": "outlined"
                    }
                  }
                },
                "editorId": "stdtextfield2"
              }
            ],
            "editorId": "column33"
          },
          {
            "type": "container",
            "properties": {
              "padding": {
                "edgeInsets": {
                  "top": 0,
                  "right": 0,
                  "bottom": 0,
                  "left": 0,
                  "token": "lg"
                }
              },
              "bg": {
                "color": {
                  "color": "background"
                }
              }
            },
            "children": [
              {
                "type": "@std.button",
                "properties": {
                  "content": {
                    "stringVal": {
                      "value": "Continue"
                    }
                  },
                  "variant": {
                    "stringVal": {
                      "value": "primary"
                    }
                  },
                  "size": {
                    "stringVal": {
                      "value": "large"
                    }
                  },
                  "full_width": {
                    "boolVal": {
                      "value": true
                    }
                  }
                },
                "editorId": "stdbutton3"
              }
            ],
            "editorId": "container30"
          }
        ],
        "editorId": "column30"
      }
    ],
    "editorId": "scaffold4"
  }
}
```

### 5. Onboarding Activity

- Frame ID: `frame6`
- Original page prompt: "Onboarding screen for activity level and meal timing preferences"
- Follow-up prompts: _None_

#### DslDocument (JSON)

```json
{
  "root": {
    "type": "scaffold",
    "properties": {
      "bg": {
        "color": {
          "color": "background"
        }
      },
      "safe_area": {
        "boolVal": {
          "value": true
        }
      }
    },
    "children": [
      {
        "type": "column",
        "properties": {
          "scroll": {
            "boolVal": {
              "value": true
            }
          },
          "cross_align": {
            "align": {
              "named": "stretch"
            }
          },
          "padding": {
            "edgeInsets": {
              "top": 0,
              "right": 0,
              "bottom": 0,
              "left": 0,
              "token": "lg"
            }
          }
        },
        "children": [
          {
            "type": "column",
            "properties": {
              "spacing": {
                "stringVal": {
                  "value": "md"
                }
              },
              "cross_align": {
                "align": {
                  "named": "start"
                }
              }
            },
            "children": [
              {
                "type": "row",
                "properties": {
                  "align": {
                    "align": {
                      "named": "space_between"
                    }
                  }
                },
                "children": [
                  {
                    "type": "iconbutton",
                    "properties": {
                      "name": {
                        "icon": {
                          "name": "arrow_back_rounded"
                        }
                      },
                      "color": {
                        "color": {
                          "color": "primary_text"
                        }
                      }
                    },
                    "editorId": "iconbutton4"
                  },
                  {
                    "type": "text",
                    "properties": {
                      "content": {
                        "stringVal": {
                          "value": "Step 5 of 8"
                        }
                      },
                      "style": {
                        "textStyle": {
                          "styleName": "label_large"
                        }
                      },
                      "color": {
                        "color": {
                          "color": "secondary_text"
                        }
                      }
                    },
                    "editorId": "text49"
                  }
                ],
                "editorId": "row20"
              },
              {
                "type": "column",
                "properties": {
                  "spacing": {
                    "stringVal": {
                      "value": "xs"
                    }
                  },
                  "cross_align": {
                    "align": {
                      "named": "stretch"
                    }
                  }
                },
                "children": [
                  {
                    "type": "progress",
                    "properties": {
                      "value": {
                        "numberVal": {
                          "value": 0.62
                        }
                      },
                      "variant": {
                        "stringVal": {
                          "value": "linear"
                        }
                      },
                      "color": {
                        "color": {
                          "color": "primary"
                        }
                      },
                      "thickness": {
                        "numberVal": {
                          "value": 6
                        }
                      },
                      "radius": {
                        "radius": {
                          "topLeft": 3,
                          "topRight": 3,
                          "bottomLeft": 3,
                          "bottomRight": 3
                        }
                      }
                    },
                    "editorId": "progress2"
                  }
                ],
                "editorId": "column36"
              },
              {
                "type": "sizedbox",
                "properties": {
                  "height": {
                    "stringVal": {
                      "value": "md"
                    }
                  }
                },
                "editorId": "sizedbox8"
              },
              {
                "type": "text",
                "properties": {
                  "content": {
                    "stringVal": {
                      "value": "How active are you?"
                    }
                  },
                  "style": {
                    "textStyle": {
                      "styleName": "headline_medium"
                    }
                  },
                  "color": {
                    "color": {
                      "color": "primary_text"
                    }
                  },
                  "font_weight": {
                    "stringVal": {
                      "value": "bold"
                    }
                  }
                },
                "editorId": "text50"
              },
              {
                "type": "text",
                "properties": {
                  "content": {
                    "stringVal": {
                      "value": "This helps us calculate your daily calorie needs accurately."
                    }
                  },
                  "style": {
                    "textStyle": {
                      "styleName": "body_medium"
                    }
                  },
                  "color": {
                    "color": {
                      "color": "secondary_text"
                    }
                  }
                },
                "editorId": "text51"
              }
            ],
            "editorId": "column35"
          },
          {
            "type": "sizedbox",
            "properties": {
              "height": {
                "stringVal": {
                  "value": "lg"
                }
              }
            },
            "editorId": "sizedbox9"
          },
          {
            "type": "column",
            "properties": {
              "spacing": {
                "numberVal": {
                  "value": 0
                }
              },
              "cross_align": {
                "align": {
                  "named": "stretch"
                }
              }
            },
            "children": [
              {
                "type": "@activity_option",
                "properties": {
                  "title": {
                    "stringVal": {
                      "value": "Sedentary"
                    }
                  },
                  "subtitle": {
                    "stringVal": {
                      "value": "Little to no exercise, desk job"
                    }
                  },
                  "icon": {
                    "stringVal": {
                      "value": "desk_rounded"
                    }
                  },
                  "selected": {
                    "boolVal": {
                      "value": false
                    }
                  }
                },
                "editorId": "activityoption1"
              },
              {
                "type": "@activity_option",
                "properties": {
                  "title": {
                    "stringVal": {
                      "value": "Lightly Active"
                    }
                  },
                  "subtitle": {
                    "stringVal": {
                      "value": "Light exercise 1-3 days/week"
                    }
                  },
                  "icon": {
                    "stringVal": {
                      "value": "directions_walk_rounded"
                    }
                  },
                  "selected": {
                    "boolVal": {
                      "value": true
                    }
                  }
                },
                "editorId": "activityoption2"
              },
              {
                "type": "@activity_option",
                "properties": {
                  "title": {
                    "stringVal": {
                      "value": "Moderately Active"
                    }
                  },
                  "subtitle": {
                    "stringVal": {
                      "value": "Moderate exercise 3-5 days/week"
                    }
                  },
                  "icon": {
                    "stringVal": {
                      "value": "fitness_center_rounded"
                    }
                  },
                  "selected": {
                    "boolVal": {
                      "value": false
                    }
                  }
                },
                "editorId": "activityoption3"
              },
              {
                "type": "@activity_option",
                "properties": {
                  "title": {
                    "stringVal": {
                      "value": "Very Active"
                    }
                  },
                  "subtitle": {
                    "stringVal": {
                      "value": "Hard exercise 6-7 days/week"
                    }
                  },
                  "icon": {
                    "stringVal": {
                      "value": "self_improvement_rounded"
                    }
                  },
                  "selected": {
                    "boolVal": {
                      "value": false
                    }
                  }
                },
                "editorId": "activityoption4"
              }
            ],
            "editorId": "column37"
          },
          {
            "type": "sizedbox",
            "properties": {
              "height": {
                "stringVal": {
                  "value": "xl"
                }
              }
            },
            "editorId": "sizedbox10"
          },
          {
            "type": "column",
            "properties": {
              "spacing": {
                "stringVal": {
                  "value": "md"
                }
              },
              "cross_align": {
                "align": {
                  "named": "start"
                }
              }
            },
            "children": [
              {
                "type": "text",
                "properties": {
                  "content": {
                    "stringVal": {
                      "value": "Preferred Meal Timing"
                    }
                  },
                  "style": {
                    "textStyle": {
                      "styleName": "title_large"
                    }
                  },
                  "color": {
                    "color": {
                      "color": "primary_text"
                    }
                  },
                  "font_weight": {
                    "stringVal": {
                      "value": "bold"
                    }
                  }
                },
                "editorId": "text52"
              },
              {
                "type": "text",
                "properties": {
                  "content": {
                    "stringVal": {
                      "value": "When do you usually like to eat? Select all that apply."
                    }
                  },
                  "style": {
                    "textStyle": {
                      "styleName": "body_medium"
                    }
                  },
                  "color": {
                    "color": {
                      "color": "secondary_text"
                    }
                  }
                },
                "editorId": "text53"
              },
              {
                "type": "wrap",
                "properties": {
                  "spacing": {
                    "stringVal": {
                      "value": "md"
                    }
                  },
                  "run_spacing": {
                    "stringVal": {
                      "value": "md"
                    }
                  }
                },
                "children": [
                  {
                    "type": "@timing_chip",
                    "properties": {
                      "label": {
                        "stringVal": {
                          "value": "Early Bird"
                        }
                      },
                      "icon": {
                        "stringVal": {
                          "value": "light_mode_rounded"
                        }
                      },
                      "selected": {
                        "boolVal": {
                          "value": true
                        }
                      }
                    },
                    "editorId": "timingchip1"
                  },
                  {
                    "type": "@timing_chip",
                    "properties": {
                      "label": {
                        "stringVal": {
                          "value": "Standard 3-Meal"
                        }
                      },
                      "icon": {
                        "stringVal": {
                          "value": "restaurant_rounded"
                        }
                      },
                      "selected": {
                        "boolVal": {
                          "value": false
                        }
                      }
                    },
                    "editorId": "timingchip2"
                  },
                  {
                    "type": "@timing_chip",
                    "properties": {
                      "label": {
                        "stringVal": {
                          "value": "Intermittent Fasting"
                        }
                      },
                      "icon": {
                        "stringVal": {
                          "value": "timer_rounded"
                        }
                      },
                      "selected": {
                        "boolVal": {
                          "value": false
                        }
                      }
                    },
                    "editorId": "timingchip3"
                  },
                  {
                    "type": "@timing_chip",
                    "properties": {
                      "label": {
                        "stringVal": {
                          "value": "Late Night"
                        }
                      },
                      "icon": {
                        "stringVal": {
                          "value": "bed_rounded"
                        }
                      },
                      "selected": {
                        "boolVal": {
                          "value": false
                        }
                      }
                    },
                    "editorId": "timingchip4"
                  },
                  {
                    "type": "@timing_chip",
                    "properties": {
                      "label": {
                        "stringVal": {
                          "value": "Frequent Snacks"
                        }
                      },
                      "icon": {
                        "stringVal": {
                          "value": "cookie_rounded"
                        }
                      },
                      "selected": {
                        "boolVal": {
                          "value": true
                        }
                      }
                    },
                    "editorId": "timingchip5"
                  }
                ],
                "editorId": "wrap2"
              }
            ],
            "editorId": "column38"
          },
          {
            "type": "sizedbox",
            "properties": {
              "height": {
                "stringVal": {
                  "value": "xl"
                }
              }
            },
            "editorId": "sizedbox11"
          },
          {
            "type": "@std.button",
            "properties": {
              "content": {
                "stringVal": {
                  "value": "Continue to Preferences"
                }
              },
              "variant": {
                "stringVal": {
                  "value": "primary"
                }
              },
              "size": {
                "stringVal": {
                  "value": "large"
                }
              },
              "full_width": {
                "boolVal": {
                  "value": true
                }
              },
              "icon_end": {
                "stringVal": {
                  "value": "arrow_forward_rounded"
                }
              }
            },
            "editorId": "stdbutton4"
          },
          {
            "type": "sizedbox",
            "properties": {
              "height": {
                "stringVal": {
                  "value": "md"
                }
              }
            },
            "editorId": "sizedbox12"
          },
          {
            "type": "center",
            "children": [
              {
                "type": "text",
                "properties": {
                  "content": {
                    "stringVal": {
                      "value": "I'll do this later"
                    }
                  },
                  "style": {
                    "textStyle": {
                      "styleName": "label_large"
                    }
                  },
                  "color": {
                    "color": {
                      "color": "secondary_text"
                    }
                  },
                  "decoration": {
                    "stringVal": {
                      "value": "underline"
                    }
                  }
                },
                "editorId": "text54"
              }
            ],
            "editorId": "center1"
          }
        ],
        "editorId": "column34"
      }
    ],
    "editorId": "scaffold5"
  }
}
```

### 6. Onboarding Metrics

- Frame ID: `frame5`
- Original page prompt: "Onboarding screen for entering age, height, current weight, and target weight"
- Follow-up prompts: _None_

#### DslDocument (JSON)

```json
{
  "root": {
    "type": "scaffold",
    "properties": {
      "bg": {
        "color": {
          "color": "background"
        }
      },
      "safe_area": {
        "boolVal": {
          "value": true
        }
      }
    },
    "children": [
      {
        "type": "column",
        "properties": {
          "scroll": {
            "boolVal": {
              "value": true
            }
          },
          "padding": {
            "edgeInsets": {
              "top": 24,
              "right": 24,
              "bottom": 24,
              "left": 24
            }
          },
          "spacing": {
            "stringVal": {
              "value": "xl"
            }
          },
          "cross_align": {
            "align": {
              "named": "stretch"
            }
          }
        },
        "children": [
          {
            "type": "column",
            "properties": {
              "spacing": {
                "stringVal": {
                  "value": "md"
                }
              },
              "cross_align": {
                "align": {
                  "named": "start"
                }
              }
            },
            "children": [
              {
                "type": "row",
                "properties": {
                  "spacing": {
                    "stringVal": {
                      "value": "md"
                    }
                  },
                  "cross_align": {
                    "align": {
                      "named": "center"
                    }
                  }
                },
                "children": [
                  {
                    "type": "expanded",
                    "children": [
                      {
                        "type": "progress",
                        "properties": {
                          "value": {
                            "numberVal": {
                              "value": 0.7
                            }
                          },
                          "thickness": {
                            "numberVal": {
                              "value": 8
                            }
                          },
                          "color": {
                            "color": {
                              "color": "primary"
                            }
                          },
                          "bg_color": {
                            "color": {
                              "color": "surface_variant"
                            }
                          }
                        },
                        "editorId": "progress3"
                      }
                    ],
                    "editorId": "expanded8"
                  },
                  {
                    "type": "text",
                    "properties": {
                      "content": {
                        "stringVal": {
                          "value": "7 of 10"
                        }
                      },
                      "style": {
                        "textStyle": {
                          "styleName": "label_medium"
                        }
                      },
                      "color": {
                        "color": {
                          "color": "secondary_text"
                        }
                      }
                    },
                    "editorId": "text55"
                  }
                ],
                "editorId": "row21"
              },
              {
                "type": "column",
                "properties": {
                  "spacing": {
                    "stringVal": {
                      "value": "xs"
                    }
                  }
                },
                "children": [
                  {
                    "type": "text",
                    "properties": {
                      "content": {
                        "stringVal": {
                          "value": "Your Metrics"
                        }
                      },
                      "style": {
                        "textStyle": {
                          "styleName": "headline_medium"
                        }
                      },
                      "color": {
                        "color": {
                          "color": "primary_text"
                        }
                      },
                      "font_weight": {
                        "stringVal": {
                          "value": "bold"
                        }
                      }
                    },
                    "editorId": "text56"
                  },
                  {
                    "type": "text",
                    "properties": {
                      "content": {
                        "stringVal": {
                          "value": "This helps AI calculate your precise caloric needs."
                        }
                      },
                      "style": {
                        "textStyle": {
                          "styleName": "body_medium"
                        }
                      },
                      "color": {
                        "color": {
                          "color": "secondary_text"
                        }
                      }
                    },
                    "editorId": "text57"
                  }
                ],
                "editorId": "column41"
              }
            ],
            "editorId": "column40"
          },
          {
            "type": "column",
            "properties": {
              "spacing": {
                "stringVal": {
                  "value": "lg"
                }
              }
            },
            "children": [
              {
                "type": "@metric_input",
                "properties": {
                  "label": {
                    "stringVal": {
                      "value": "Age"
                    }
                  },
                  "hint": {
                    "stringVal": {
                      "value": "e.g. 28"
                    }
                  },
                  "unit": {
                    "stringVal": {
                      "value": "Years"
                    }
                  },
                  "value": {
                    "stringVal": {
                      "value": ""
                    }
                  }
                },
                "editorId": "metricinput1"
              },
              {
                "type": "@metric_input",
                "properties": {
                  "label": {
                    "stringVal": {
                      "value": "Height"
                    }
                  },
                  "hint": {
                    "stringVal": {
                      "value": "e.g. 175"
                    }
                  },
                  "unit": {
                    "stringVal": {
                      "value": "cm"
                    }
                  },
                  "value": {
                    "stringVal": {
                      "value": ""
                    }
                  }
                },
                "editorId": "metricinput2"
              },
              {
                "type": "row",
                "properties": {
                  "spacing": {
                    "stringVal": {
                      "value": "lg"
                    }
                  }
                },
                "children": [
                  {
                    "type": "expanded",
                    "children": [
                      {
                        "type": "@metric_input",
                        "properties": {
                          "label": {
                            "stringVal": {
                              "value": "Current Weight"
                            }
                          },
                          "hint": {
                            "stringVal": {
                              "value": "75"
                            }
                          },
                          "unit": {
                            "stringVal": {
                              "value": "kg"
                            }
                          },
                          "value": {
                            "stringVal": {
                              "value": ""
                            }
                          }
                        },
                        "editorId": "metricinput3"
                      }
                    ],
                    "editorId": "expanded9"
                  },
                  {
                    "type": "expanded",
                    "children": [
                      {
                        "type": "@metric_input",
                        "properties": {
                          "label": {
                            "stringVal": {
                              "value": "Target Weight"
                            }
                          },
                          "hint": {
                            "stringVal": {
                              "value": "70"
                            }
                          },
                          "unit": {
                            "stringVal": {
                              "value": "kg"
                            }
                          },
                          "value": {
                            "stringVal": {
                              "value": ""
                            }
                          }
                        },
                        "editorId": "metricinput4"
                      }
                    ],
                    "editorId": "expanded10"
                  }
                ],
                "editorId": "row22"
              }
            ],
            "editorId": "column42"
          },
          {
            "type": "container",
            "properties": {
              "bg": {
                "color": {
                  "color": "info",
                  "opacityPercent": 10
                }
              },
              "radius": {
                "radius": {
                  "topLeft": 0,
                  "topRight": 0,
                  "bottomLeft": 0,
                  "bottomRight": 0,
                  "token": "lg"
                }
              },
              "padding": {
                "edgeInsets": {
                  "top": 0,
                  "right": 0,
                  "bottom": 0,
                  "left": 0,
                  "token": "lg"
                }
              },
              "border": {
                "border": {
                  "width": 1,
                  "color": "info/30"
                }
              }
            },
            "children": [
              {
                "type": "row",
                "properties": {
                  "spacing": {
                    "stringVal": {
                      "value": "md"
                    }
                  },
                  "cross_align": {
                    "align": {
                      "named": "start"
                    }
                  }
                },
                "children": [
                  {
                    "type": "icon",
                    "properties": {
                      "name": {
                        "icon": {
                          "name": "info_rounded"
                        }
                      },
                      "color": {
                        "color": {
                          "color": "on_info"
                        }
                      },
                      "size": {
                        "numberVal": {
                          "value": 22
                        }
                      }
                    },
                    "editorId": "icon16"
                  },
                  {
                    "type": "expanded",
                    "children": [
                      {
                        "type": "text",
                        "properties": {
                          "content": {
                            "stringVal": {
                              "value": "We use the Mifflin-St Jeor equation to estimate your basal metabolic rate (BMR)."
                            }
                          },
                          "style": {
                            "textStyle": {
                              "styleName": "body_small"
                            }
                          },
                          "color": {
                            "color": {
                              "color": "on_info"
                            }
                          },
                          "line_height": {
                            "numberVal": {
                              "value": 1.4
                            }
                          }
                        },
                        "editorId": "text58"
                      }
                    ],
                    "editorId": "expanded11"
                  }
                ],
                "editorId": "row23"
              }
            ],
            "editorId": "container31"
          },
          {
            "type": "container",
            "properties": {
              "height": {
                "px": {
                  "value": 180,
                  "isInfinity": false
                }
              },
              "align_child": {
                "align": {
                  "named": "center"
                }
              }
            },
            "children": [
              {
                "type": "lottie",
                "properties": {
                  "source_desc": {
                    "imageSource": {
                      "type": "IMAGE_SOURCE_TYPE_URL",
                      "value": "https://dimg.dreamflow.cloud/v1/image/person+measuring+height+and+weight+animation"
                    }
                  },
                  "height": {
                    "px": {
                      "value": 160,
                      "isInfinity": false
                    }
                  },
                  "fit": {
                    "stringVal": {
                      "value": "contain"
                    }
                  }
                },
                "editorId": "lottie2"
              }
            ],
            "editorId": "container32"
          },
          {
            "type": "column",
            "properties": {
              "spacing": {
                "stringVal": {
                  "value": "md"
                }
              }
            },
            "children": [
              {
                "type": "@std.button",
                "properties": {
                  "content": {
                    "stringVal": {
                      "value": "Continue"
                    }
                  },
                  "variant": {
                    "stringVal": {
                      "value": "primary"
                    }
                  },
                  "size": {
                    "stringVal": {
                      "value": "large"
                    }
                  },
                  "full_width": {
                    "boolVal": {
                      "value": true
                    }
                  }
                },
                "editorId": "stdbutton5"
              },
              {
                "type": "@std.button",
                "properties": {
                  "content": {
                    "stringVal": {
                      "value": "Go Back"
                    }
                  },
                  "variant": {
                    "stringVal": {
                      "value": "ghost"
                    }
                  },
                  "size": {
                    "stringVal": {
                      "value": "medium"
                    }
                  },
                  "full_width": {
                    "boolVal": {
                      "value": true
                    }
                  },
                  "color": {
                    "stringVal": {
                      "value": "secondary_text"
                    }
                  }
                },
                "editorId": "stdbutton6"
              }
            ],
            "editorId": "column43"
          }
        ],
        "editorId": "column39"
      }
    ],
    "editorId": "scaffold6"
  }
}
```

### 7. Generating Plan

- Frame ID: `frame4`
- Original page prompt: "A loading screen with a progress indicator while the AI generates the meal plan"
- Follow-up prompts: _None_

#### DslDocument (JSON)

```json
{
  "root": {
    "type": "scaffold",
    "properties": {
      "bg": {
        "color": {
          "color": "background"
        }
      }
    },
    "children": [
      {
        "type": "column",
        "properties": {
          "align": {
            "align": {
              "named": "center"
            }
          },
          "cross_align": {
            "align": {
              "named": "center"
            }
          },
          "padding": {
            "edgeInsets": {
              "top": 0,
              "right": 0,
              "bottom": 0,
              "left": 0,
              "token": "xl"
            }
          },
          "spacing": {
            "stringVal": {
              "value": "xl"
            }
          }
        },
        "children": [
          {
            "type": "column",
            "properties": {
              "spacing": {
                "stringVal": {
                  "value": "md"
                }
              },
              "align": {
                "align": {
                  "named": "center"
                }
              }
            },
            "children": [
              {
                "type": "container",
                "properties": {
                  "width": {
                    "px": {
                      "value": 64,
                      "isInfinity": false
                    }
                  },
                  "height": {
                    "px": {
                      "value": 64,
                      "isInfinity": false
                    }
                  },
                  "radius": {
                    "radius": {
                      "topLeft": 20,
                      "topRight": 20,
                      "bottomLeft": 20,
                      "bottomRight": 20
                    }
                  },
                  "bg": {
                    "color": {
                      "color": "primary_container"
                    }
                  },
                  "align_child": {
                    "align": {
                      "named": "center"
                    }
                  }
                },
                "children": [
                  {
                    "type": "icon",
                    "properties": {
                      "name": {
                        "icon": {
                          "name": "restaurant_rounded"
                        }
                      },
                      "color": {
                        "color": {
                          "color": "on_primary"
                        }
                      },
                      "size": {
                        "numberVal": {
                          "value": 32
                        }
                      }
                    },
                    "editorId": "icon17"
                  }
                ],
                "editorId": "container33"
              },
              {
                "type": "text",
                "properties": {
                  "content": {
                    "stringVal": {
                      "value": "NourishPath"
                    }
                  },
                  "style": {
                    "textStyle": {
                      "styleName": "title_medium"
                    }
                  },
                  "color": {
                    "color": {
                      "color": "primary"
                    }
                  },
                  "font_weight": {
                    "stringVal": {
                      "value": "bold"
                    }
                  }
                },
                "editorId": "text59"
              }
            ],
            "editorId": "column45"
          },
          {
            "type": "expanded",
            "children": [
              {
                "type": "column",
                "properties": {
                  "align": {
                    "align": {
                      "named": "center"
                    }
                  },
                  "spacing": {
                    "stringVal": {
                      "value": "lg"
                    }
                  }
                },
                "children": [
                  {
                    "type": "stack",
                    "properties": {
                      "width": {
                        "px": {
                          "value": 280,
                          "isInfinity": false
                        }
                      },
                      "height": {
                        "px": {
                          "value": 280,
                          "isInfinity": false
                        }
                      },
                      "align": {
                        "align": {
                          "named": "center"
                        }
                      }
                    },
                    "children": [
                      {
                        "type": "container",
                        "properties": {
                          "width": {
                            "px": {
                              "value": 240,
                              "isInfinity": false
                            }
                          },
                          "height": {
                            "px": {
                              "value": 240,
                              "isInfinity": false
                            }
                          },
                          "radius": {
                            "radius": {
                              "topLeft": 0,
                              "topRight": 0,
                              "bottomLeft": 0,
                              "bottomRight": 0,
                              "token": "full"
                            }
                          },
                          "border": {
                            "border": {
                              "width": 4,
                              "color": "surface_variant"
                            }
                          }
                        },
                        "editorId": "container34"
                      },
                      {
                        "type": "lottie",
                        "properties": {
                          "source_desc": {
                            "imageSource": {
                              "type": "IMAGE_SOURCE_TYPE_URL",
                              "value": "https://dimg.dreamflow.cloud/v1/image/chef+preparing+meal+healthy+food+animation"
                            }
                          },
                          "width": {
                            "px": {
                              "value": 220,
                              "isInfinity": false
                            }
                          },
                          "height": {
                            "px": {
                              "value": 220,
                              "isInfinity": false
                            }
                          },
                          "fit": {
                            "stringVal": {
                              "value": "contain"
                            }
                          }
                        },
                        "editorId": "lottie3"
                      }
                    ],
                    "editorId": "stack3"
                  },
                  {
                    "type": "column",
                    "properties": {
                      "spacing": {
                        "stringVal": {
                          "value": "sm"
                        }
                      },
                      "align": {
                        "align": {
                          "named": "center"
                        }
                      }
                    },
                    "children": [
                      {
                        "type": "text",
                        "properties": {
                          "content": {
                            "stringVal": {
                              "value": "Crafting your perfect menu..."
                            }
                          },
                          "style": {
                            "textStyle": {
                              "styleName": "headline_small"
                            }
                          },
                          "text_align": {
                            "align": {
                              "named": "center"
                            }
                          },
                          "font_weight": {
                            "stringVal": {
                              "value": "bold"
                            }
                          }
                        },
                        "editorId": "text60"
                      },
                      {
                        "type": "text",
                        "properties": {
                          "content": {
                            "stringVal": {
                              "value": "Analyzing your preferences & nutritional goals"
                            }
                          },
                          "style": {
                            "textStyle": {
                              "styleName": "body_medium"
                            }
                          },
                          "color": {
                            "color": {
                              "color": "secondary_text"
                            }
                          },
                          "text_align": {
                            "align": {
                              "named": "center"
                            }
                          }
                        },
                        "editorId": "text61"
                      }
                    ],
                    "editorId": "column47"
                  },
                  {
                    "type": "column",
                    "properties": {
                      "spacing": {
                        "stringVal": {
                          "value": "md"
                        }
                      },
                      "width": {
                        "px": {
                          "value": 240,
                          "isInfinity": false
                        }
                      }
                    },
                    "children": [
                      {
                        "type": "progress",
                        "properties": {
                          "variant": {
                            "stringVal": {
                              "value": "linear"
                            }
                          },
                          "value": {
                            "numberVal": {
                              "value": 0.65
                            }
                          },
                          "color": {
                            "color": {
                              "color": "primary"
                            }
                          },
                          "bg_color": {
                            "color": {
                              "color": "surface_variant"
                            }
                          },
                          "thickness": {
                            "numberVal": {
                              "value": 8
                            }
                          },
                          "radius": {
                            "radius": {
                              "topLeft": 4,
                              "topRight": 4,
                              "bottomLeft": 4,
                              "bottomRight": 4
                            }
                          }
                        },
                        "editorId": "progress4"
                      },
                      {
                        "type": "row",
                        "properties": {
                          "align": {
                            "align": {
                              "named": "space_between"
                            }
                          }
                        },
                        "children": [
                          {
                            "type": "text",
                            "properties": {
                              "content": {
                                "stringVal": {
                                  "value": "65% Complete"
                                }
                              },
                              "style": {
                                "textStyle": {
                                  "styleName": "label_medium"
                                }
                              },
                              "color": {
                                "color": {
                                  "color": "secondary_text"
                                }
                              }
                            },
                            "editorId": "text62"
                          },
                          {
                            "type": "text",
                            "properties": {
                              "content": {
                                "stringVal": {
                                  "value": "Almost there"
                                }
                              },
                              "style": {
                                "textStyle": {
                                  "styleName": "label_medium"
                                }
                              },
                              "color": {
                                "color": {
                                  "color": "primary"
                                }
                              },
                              "font_weight": {
                                "numberVal": {
                                  "value": 600
                                }
                              }
                            },
                            "editorId": "text63"
                          }
                        ],
                        "editorId": "row24"
                      }
                    ],
                    "editorId": "column48"
                  }
                ],
                "editorId": "column46"
              }
            ],
            "editorId": "expanded12"
          },
          {
            "type": "container",
            "properties": {
              "bg": {
                "color": {
                  "color": "surface"
                }
              },
              "radius": {
                "radius": {
                  "topLeft": 0,
                  "topRight": 0,
                  "bottomLeft": 0,
                  "bottomRight": 0,
                  "token": "lg"
                }
              },
              "padding": {
                "edgeInsets": {
                  "top": 0,
                  "right": 0,
                  "bottom": 0,
                  "left": 0,
                  "token": "lg"
                }
              },
              "shadow": {
                "stringVal": {
                  "value": "sm"
                }
              },
              "border": {
                "border": {
                  "width": 1,
                  "color": "divider"
                }
              }
            },
            "children": [
              {
                "type": "row",
                "properties": {
                  "spacing": {
                    "stringVal": {
                      "value": "md"
                    }
                  },
                  "cross_align": {
                    "align": {
                      "named": "start"
                    }
                  }
                },
                "children": [
                  {
                    "type": "container",
                    "properties": {
                      "width": {
                        "px": {
                          "value": 40,
                          "isInfinity": false
                        }
                      },
                      "height": {
                        "px": {
                          "value": 40,
                          "isInfinity": false
                        }
                      },
                      "radius": {
                        "radius": {
                          "topLeft": 0,
                          "topRight": 0,
                          "bottomLeft": 0,
                          "bottomRight": 0,
                          "token": "full"
                        }
                      },
                      "bg": {
                        "color": {
                          "color": "info_container"
                        }
                      },
                      "align_child": {
                        "align": {
                          "named": "center"
                        }
                      }
                    },
                    "children": [
                      {
                        "type": "icon",
                        "properties": {
                          "name": {
                            "icon": {
                              "name": "auto_awesome_rounded"
                            }
                          },
                          "color": {
                            "color": {
                              "color": "info"
                            }
                          },
                          "size": {
                            "numberVal": {
                              "value": 20
                            }
                          }
                        },
                        "editorId": "icon18"
                      }
                    ],
                    "editorId": "container36"
                  },
                  {
                    "type": "expanded",
                    "children": [
                      {
                        "type": "column",
                        "properties": {
                          "cross_align": {
                            "align": {
                              "named": "start"
                            }
                          },
                          "spacing": {
                            "stringVal": {
                              "value": "xs"
                            }
                          }
                        },
                        "children": [
                          {
                            "type": "text",
                            "properties": {
                              "content": {
                                "stringVal": {
                                  "value": "AI Personalization"
                                }
                              },
                              "style": {
                                "textStyle": {
                                  "styleName": "label_large"
                                }
                              },
                              "font_weight": {
                                "stringVal": {
                                  "value": "bold"
                                }
                              },
                              "color": {
                                "color": {
                                  "color": "primary_text"
                                }
                              }
                            },
                            "editorId": "text64"
                          },
                          {
                            "type": "text",
                            "properties": {
                              "content": {
                                "stringVal": {
                                  "value": "We're balancing your macros to ensure you stay energized throughout the day."
                                }
                              },
                              "style": {
                                "textStyle": {
                                  "styleName": "body_small"
                                }
                              },
                              "color": {
                                "color": {
                                  "color": "secondary_text"
                                }
                              },
                              "max_lines": {
                                "numberVal": {
                                  "value": 2
                                }
                              },
                              "overflow": {
                                "stringVal": {
                                  "value": "ellipsis"
                                }
                              }
                            },
                            "editorId": "text65"
                          }
                        ],
                        "editorId": "column49"
                      }
                    ],
                    "editorId": "expanded13"
                  }
                ],
                "editorId": "row25"
              }
            ],
            "editorId": "container35"
          },
          {
            "type": "row",
            "properties": {
              "spacing": {
                "stringVal": {
                  "value": "sm"
                }
              },
              "padding": {
                "edgeInsets": {
                  "top": 0,
                  "right": 0,
                  "bottom": 0,
                  "left": 0,
                  "token": "lg"
                }
              },
              "align": {
                "align": {
                  "named": "center"
                }
              }
            },
            "children": [
              {
                "type": "@step_indicator",
                "properties": {
                  "active": {
                    "boolVal": {
                      "value": false
                    }
                  }
                },
                "editorId": "stepindicator1"
              },
              {
                "type": "@step_indicator",
                "properties": {
                  "active": {
                    "boolVal": {
                      "value": false
                    }
                  }
                },
                "editorId": "stepindicator2"
              },
              {
                "type": "@step_indicator",
                "properties": {
                  "active": {
                    "boolVal": {
                      "value": true
                    }
                  }
                },
                "editorId": "stepindicator3"
              }
            ],
            "editorId": "row26"
          }
        ],
        "editorId": "column44"
      }
    ],
    "editorId": "scaffold7"
  }
}
```

### 8. Daily Meal Plan

- Frame ID: `frame10`
- Original page prompt: "AI-generated daily overview showing breakfast, lunch, dinner, and snacks"
- Follow-up prompts: _None_

#### DslDocument (JSON)

```json
{
  "root": {
    "type": "scaffold",
    "properties": {
      "bg": {
        "color": {
          "color": "background"
        }
      }
    },
    "children": [
      {
        "type": "column",
        "properties": {
          "cross_align": {
            "align": {
              "named": "stretch"
            }
          }
        },
        "children": [
          {
            "type": "container",
            "properties": {
              "bg": {
                "color": {
                  "color": "surface"
                }
              },
              "padding": {
                "edgeInsets": {
                  "top": 60,
                  "right": 0,
                  "bottom": 20,
                  "left": 0,
                  "rightToken": "lg",
                  "leftToken": "lg"
                }
              },
              "radius": {
                "radius": {
                  "topLeft": 0,
                  "topRight": 0,
                  "bottomLeft": 0,
                  "bottomRight": 0,
                  "bottomLeftToken": "xl",
                  "bottomRightToken": "xl"
                }
              },
              "shadow": {
                "stringVal": {
                  "value": "sm"
                }
              }
            },
            "children": [
              {
                "type": "column",
                "properties": {
                  "spacing": {
                    "stringVal": {
                      "value": "md"
                    }
                  },
                  "cross_align": {
                    "align": {
                      "named": "start"
                    }
                  }
                },
                "children": [
                  {
                    "type": "row",
                    "properties": {
                      "align": {
                        "align": {
                          "named": "space_between"
                        }
                      }
                    },
                    "children": [
                      {
                        "type": "column",
                        "properties": {
                          "cross_align": {
                            "align": {
                              "named": "start"
                            }
                          },
                          "spacing": {
                            "numberVal": {
                              "value": 4
                            }
                          }
                        },
                        "children": [
                          {
                            "type": "text",
                            "properties": {
                              "content": {
                                "stringVal": {
                                  "value": "Today, Oct 24"
                                }
                              },
                              "style": {
                                "textStyle": {
                                  "styleName": "label_medium"
                                }
                              },
                              "color": {
                                "color": {
                                  "color": "secondary_text"
                                }
                              }
                            },
                            "editorId": "text66"
                          },
                          {
                            "type": "text",
                            "properties": {
                              "content": {
                                "stringVal": {
                                  "value": "Your AI Plan"
                                }
                              },
                              "style": {
                                "textStyle": {
                                  "styleName": "headline_medium"
                                }
                              },
                              "font_weight": {
                                "stringVal": {
                                  "value": "bold"
                                }
                              },
                              "color": {
                                "color": {
                                  "color": "primary_text"
                                }
                              }
                            },
                            "editorId": "text67"
                          }
                        ],
                        "editorId": "column52"
                      },
                      {
                        "type": "avatar",
                        "properties": {
                          "text": {
                            "stringVal": {
                              "value": "JD"
                            }
                          },
                          "bg": {
                            "color": {
                              "color": "primary_container"
                            }
                          },
                          "color": {
                            "color": {
                              "color": "on_primary_container"
                            }
                          },
                          "size": {
                            "numberVal": {
                              "value": 48
                            }
                          }
                        },
                        "editorId": "avatar1"
                      }
                    ],
                    "editorId": "row27"
                  },
                  {
                    "type": "container",
                    "properties": {
                      "bg": {
                        "color": {
                          "color": "primary"
                        }
                      },
                      "radius": {
                        "radius": {
                          "topLeft": 0,
                          "topRight": 0,
                          "bottomLeft": 0,
                          "bottomRight": 0,
                          "token": "lg"
                        }
                      },
                      "padding": {
                        "edgeInsets": {
                          "top": 0,
                          "right": 0,
                          "bottom": 0,
                          "left": 0,
                          "token": "lg"
                        }
                      },
                      "width": {
                        "px": {
                          "value": "Infinity",
                          "isInfinity": true
                        }
                      }
                    },
                    "children": [
                      {
                        "type": "row",
                        "properties": {
                          "align": {
                            "align": {
                              "named": "space_between"
                            }
                          }
                        },
                        "children": [
                          {
                            "type": "column",
                            "properties": {
                              "cross_align": {
                                "align": {
                                  "named": "start"
                                }
                              },
                              "spacing": {
                                "stringVal": {
                                  "value": "xs"
                                }
                              }
                            },
                            "children": [
                              {
                                "type": "text",
                                "properties": {
                                  "content": {
                                    "stringVal": {
                                      "value": "Daily Target"
                                    }
                                  },
                                  "color": {
                                    "color": {
                                      "color": "on_primary"
                                    }
                                  },
                                  "style": {
                                    "textStyle": {
                                      "styleName": "label_medium"
                                    }
                                  },
                                  "opacity": {
                                    "numberVal": {
                                      "value": 0.8
                                    }
                                  }
                                },
                                "editorId": "text68"
                              },
                              {
                                "type": "text",
                                "properties": {
                                  "content": {
                                    "stringVal": {
                                      "value": "1,850 / 2,200 kcal"
                                    }
                                  },
                                  "color": {
                                    "color": {
                                      "color": "on_primary"
                                    }
                                  },
                                  "style": {
                                    "textStyle": {
                                      "styleName": "title_large"
                                    }
                                  },
                                  "font_weight": {
                                    "stringVal": {
                                      "value": "bold"
                                    }
                                  }
                                },
                                "editorId": "text69"
                              }
                            ],
                            "editorId": "column53"
                          },
                          {
                            "type": "stack",
                            "properties": {
                              "width": {
                                "px": {
                                  "value": 50,
                                  "isInfinity": false
                                }
                              },
                              "height": {
                                "px": {
                                  "value": 50,
                                  "isInfinity": false
                                }
                              }
                            },
                            "children": [
                              {
                                "type": "progress",
                                "properties": {
                                  "value": {
                                    "numberVal": {
                                      "value": 1
                                    }
                                  },
                                  "variant": {
                                    "stringVal": {
                                      "value": "circular"
                                    }
                                  },
                                  "color": {
                                    "color": {
                                      "color": "on_primary",
                                      "opacityPercent": 20
                                    }
                                  },
                                  "thickness": {
                                    "numberVal": {
                                      "value": 6
                                    }
                                  },
                                  "size": {
                                    "numberVal": {
                                      "value": 50
                                    }
                                  }
                                },
                                "editorId": "progress5"
                              },
                              {
                                "type": "progress",
                                "properties": {
                                  "value": {
                                    "numberVal": {
                                      "value": 0.84
                                    }
                                  },
                                  "variant": {
                                    "stringVal": {
                                      "value": "circular"
                                    }
                                  },
                                  "color": {
                                    "color": {
                                      "color": "on_primary"
                                    }
                                  },
                                  "thickness": {
                                    "numberVal": {
                                      "value": 6
                                    }
                                  },
                                  "size": {
                                    "numberVal": {
                                      "value": 50
                                    }
                                  }
                                },
                                "editorId": "progress6"
                              },
                              {
                                "type": "center",
                                "children": [
                                  {
                                    "type": "text",
                                    "properties": {
                                      "content": {
                                        "stringVal": {
                                          "value": "84%"
                                        }
                                      },
                                      "color": {
                                        "color": {
                                          "color": "on_primary"
                                        }
                                      },
                                      "style": {
                                        "textStyle": {
                                          "styleName": "label_small"
                                        }
                                      },
                                      "font_weight": {
                                        "stringVal": {
                                          "value": "bold"
                                        }
                                      }
                                    },
                                    "editorId": "text70"
                                  }
                                ],
                                "editorId": "center2"
                              }
                            ],
                            "editorId": "stack4"
                          }
                        ],
                        "editorId": "row28"
                      }
                    ],
                    "editorId": "container38"
                  }
                ],
                "editorId": "column51"
              }
            ],
            "editorId": "container37"
          },
          {
            "type": "expanded",
            "children": [
              {
                "type": "column",
                "properties": {
                  "scroll": {
                    "boolVal": {
                      "value": true
                    }
                  },
                  "padding": {
                    "edgeInsets": {
                      "top": 0,
                      "right": 0,
                      "bottom": 0,
                      "left": 0,
                      "token": "lg"
                    }
                  },
                  "spacing": {
                    "stringVal": {
                      "value": "sm"
                    }
                  }
                },
                "children": [
                  {
                    "type": "row",
                    "properties": {
                      "align": {
                        "align": {
                          "named": "space_between"
                        }
                      }
                    },
                    "children": [
                      {
                        "type": "text",
                        "properties": {
                          "content": {
                            "stringVal": {
                              "value": "Scheduled Meals"
                            }
                          },
                          "style": {
                            "textStyle": {
                              "styleName": "title_medium"
                            }
                          },
                          "font_weight": {
                            "stringVal": {
                              "value": "bold"
                            }
                          }
                        },
                        "editorId": "text71"
                      },
                      {
                        "type": "text",
                        "properties": {
                          "content": {
                            "stringVal": {
                              "value": "AI Optimized"
                            }
                          },
                          "style": {
                            "textStyle": {
                              "styleName": "label_small"
                            }
                          },
                          "color": {
                            "color": {
                              "color": "success"
                            }
                          },
                          "font_weight": {
                            "stringVal": {
                              "value": "bold"
                            }
                          }
                        },
                        "editorId": "text72"
                      }
                    ],
                    "editorId": "row29"
                  },
                  {
                    "type": "sizedbox",
                    "properties": {
                      "height": {
                        "stringVal": {
                          "value": "xs"
                        }
                      }
                    },
                    "editorId": "gap1"
                  },
                  {
                    "type": "@meal_card",
                    "properties": {
                      "type": {
                        "stringVal": {
                          "value": "BREAKFAST"
                        }
                      },
                      "title": {
                        "stringVal": {
                          "value": "Avocado Toast with Egg"
                        }
                      },
                      "calories": {
                        "numberVal": {
                          "value": 340
                        }
                      },
                      "protein": {
                        "numberVal": {
                          "value": 18
                        }
                      },
                      "carbs": {
                        "numberVal": {
                          "value": 24
                        }
                      },
                      "fat": {
                        "numberVal": {
                          "value": 20
                        }
                      },
                      "img_desc": {
                        "stringVal": {
                          "value": "avocado toast with poached egg on a white plate"
                        }
                      }
                    },
                    "editorId": "mealcard1"
                  },
                  {
                    "type": "@meal_card",
                    "properties": {
                      "type": {
                        "stringVal": {
                          "value": "LUNCH"
                        }
                      },
                      "title": {
                        "stringVal": {
                          "value": "Grilled Chicken Quinoa Bowl"
                        }
                      },
                      "calories": {
                        "numberVal": {
                          "value": 520
                        }
                      },
                      "protein": {
                        "numberVal": {
                          "value": 42
                        }
                      },
                      "carbs": {
                        "numberVal": {
                          "value": 45
                        }
                      },
                      "fat": {
                        "numberVal": {
                          "value": 12
                        }
                      },
                      "img_desc": {
                        "stringVal": {
                          "value": "healthy quinoa bowl with grilled chicken and vegetables"
                        }
                      }
                    },
                    "editorId": "mealcard2"
                  },
                  {
                    "type": "@meal_card",
                    "properties": {
                      "type": {
                        "stringVal": {
                          "value": "SNACK"
                        }
                      },
                      "title": {
                        "stringVal": {
                          "value": "Greek Yogurt & Berries"
                        }
                      },
                      "calories": {
                        "numberVal": {
                          "value": 180
                        }
                      },
                      "protein": {
                        "numberVal": {
                          "value": 15
                        }
                      },
                      "carbs": {
                        "numberVal": {
                          "value": 20
                        }
                      },
                      "fat": {
                        "numberVal": {
                          "value": 4
                        }
                      },
                      "img_desc": {
                        "stringVal": {
                          "value": "bowl of greek yogurt topped with blueberries and honey"
                        }
                      }
                    },
                    "editorId": "mealcard3"
                  },
                  {
                    "type": "@meal_card",
                    "properties": {
                      "type": {
                        "stringVal": {
                          "value": "DINNER"
                        }
                      },
                      "title": {
                        "stringVal": {
                          "value": "Baked Salmon & Asparagus"
                        }
                      },
                      "calories": {
                        "numberVal": {
                          "value": 450
                        }
                      },
                      "protein": {
                        "numberVal": {
                          "value": 35
                        }
                      },
                      "carbs": {
                        "numberVal": {
                          "value": 10
                        }
                      },
                      "fat": {
                        "numberVal": {
                          "value": 28
                        }
                      },
                      "img_desc": {
                        "stringVal": {
                          "value": "baked salmon fillet with roasted asparagus spears"
                        }
                      }
                    },
                    "editorId": "mealcard4"
                  },
                  {
                    "type": "container",
                    "properties": {
                      "bg": {
                        "color": {
                          "color": "surface"
                        }
                      },
                      "radius": {
                        "radius": {
                          "topLeft": 0,
                          "topRight": 0,
                          "bottomLeft": 0,
                          "bottomRight": 0,
                          "token": "xl"
                        }
                      },
                      "padding": {
                        "edgeInsets": {
                          "top": 0,
                          "right": 0,
                          "bottom": 0,
                          "left": 0,
                          "token": "lg"
                        }
                      },
                      "margin": {
                        "edgeInsets": {
                          "top": 0,
                          "right": 0,
                          "bottom": 0,
                          "left": 0,
                          "bottomToken": "xl"
                        }
                      }
                    },
                    "children": [
                      {
                        "type": "column",
                        "properties": {
                          "spacing": {
                            "stringVal": {
                              "value": "md"
                            }
                          },
                          "cross_align": {
                            "align": {
                              "named": "start"
                            }
                          }
                        },
                        "children": [
                          {
                            "type": "text",
                            "properties": {
                              "content": {
                                "stringVal": {
                                  "value": "Macros Distribution"
                                }
                              },
                              "style": {
                                "textStyle": {
                                  "styleName": "title_small"
                                }
                              },
                              "font_weight": {
                                "stringVal": {
                                  "value": "bold"
                                }
                              }
                            },
                            "editorId": "text73"
                          },
                          {
                            "type": "@std.pie_chart",
                            "properties": {
                              "variant": {
                                "stringVal": {
                                  "value": "donut"
                                }
                              },
                              "data": {
                                "stringVal": {
                                  "value": "30,45,25"
                                }
                              },
                              "labels": {
                                "stringVal": {
                                  "value": "Protein,Carbs,Fat"
                                }
                              },
                              "colors": {
                                "stringVal": {
                                  "value": "primary,accent,warning"
                                }
                              },
                              "size": {
                                "stringVal": {
                                  "value": "medium"
                                }
                              },
                              "ring": {
                                "stringVal": {
                                  "value": "medium"
                                }
                              },
                              "legend": {
                                "stringVal": {
                                  "value": "right"
                                }
                              },
                              "legend_value": {
                                "stringVal": {
                                  "value": "percent"
                                }
                              }
                            },
                            "editorId": "piechart1"
                          }
                        ],
                        "editorId": "column55"
                      }
                    ],
                    "editorId": "container39"
                  }
                ],
                "editorId": "column54"
              }
            ],
            "editorId": "expanded14"
          },
          {
            "type": "container",
            "properties": {
              "padding": {
                "edgeInsets": {
                  "top": 0,
                  "right": 0,
                  "bottom": 0,
                  "left": 0,
                  "token": "lg"
                }
              },
              "bg": {
                "color": {
                  "color": "background"
                }
              }
            },
            "children": [
              {
                "type": "@std.button",
                "properties": {
                  "content": {
                    "stringVal": {
                      "value": "Regenerate AI Plan"
                    }
                  },
                  "variant": {
                    "stringVal": {
                      "value": "outline"
                    }
                  },
                  "icon": {
                    "stringVal": {
                      "value": "auto_awesome_rounded"
                    }
                  },
                  "full_width": {
                    "boolVal": {
                      "value": true
                    }
                  }
                },
                "editorId": "stdbutton7"
              }
            ],
            "editorId": "container40"
          }
        ],
        "editorId": "column50"
      }
    ],
    "editorId": "scaffold8"
  }
}
```

### 9. Meal Details

- Frame ID: `frame9`
- Original page prompt: "Detailed view of a specific meal with calories, macros, and quick instructions"
- Follow-up prompts: _None_

#### DslDocument (JSON)

```json
{
  "root": {
    "type": "scaffold",
    "properties": {
      "bg": {
        "color": {
          "color": "background"
        }
      },
      "safe_area": {
        "boolVal": {
          "value": true
        }
      }
    },
    "children": [
      {
        "type": "column",
        "properties": {
          "scroll": {
            "boolVal": {
              "value": true
            }
          },
          "cross_align": {
            "align": {
              "named": "stretch"
            }
          }
        },
        "children": [
          {
            "type": "stack",
            "properties": {
              "height": {
                "px": {
                  "value": 320,
                  "isInfinity": false
                }
              }
            },
            "children": [
              {
                "type": "image",
                "properties": {
                  "source_desc": {
                    "imageSource": {
                      "type": "IMAGE_SOURCE_TYPE_URL",
                      "value": "https://dimg.dreamflow.cloud/v1/image/delicious+healthy+avocado+toast+with+poached+egg+and+seeds"
                    }
                  },
                  "fit": {
                    "stringVal": {
                      "value": "cover"
                    }
                  },
                  "width": {
                    "px": {
                      "value": "Infinity",
                      "isInfinity": true
                    }
                  },
                  "height": {
                    "px": {
                      "value": 320,
                      "isInfinity": false
                    }
                  }
                },
                "editorId": "image2"
              },
              {
                "type": "container",
                "properties": {
                  "gradient": {
                    "gradient": {
                      "type": "GRADIENT_TYPE_LINEAR",
                      "direction": "to_bottom",
                      "stops": [
                        {
                          "color": "transparent",
                          "position": 60
                        },
                        {
                          "color": "background",
                          "position": 100
                        }
                      ]
                    }
                  },
                  "height": {
                    "px": {
                      "value": 320,
                      "isInfinity": false
                    }
                  }
                },
                "editorId": "container41"
              },
              {
                "type": "container",
                "properties": {
                  "align": {
                    "align": {
                      "named": "top_left"
                    }
                  },
                  "padding": {
                    "edgeInsets": {
                      "top": 0,
                      "right": 0,
                      "bottom": 0,
                      "left": 0,
                      "token": "lg"
                    }
                  }
                },
                "children": [
                  {
                    "type": "iconbutton",
                    "properties": {
                      "name": {
                        "icon": {
                          "name": "arrow_back_rounded"
                        }
                      },
                      "bg": {
                        "color": {
                          "color": "surface",
                          "opacityPercent": 80
                        }
                      },
                      "color": {
                        "color": {
                          "color": "primary_text"
                        }
                      },
                      "radius": {
                        "radius": {
                          "topLeft": 0,
                          "topRight": 0,
                          "bottomLeft": 0,
                          "bottomRight": 0,
                          "token": "full"
                        }
                      },
                      "size": {
                        "numberVal": {
                          "value": 24
                        }
                      }
                    },
                    "editorId": "iconbutton5"
                  }
                ],
                "editorId": "container42"
              },
              {
                "type": "container",
                "properties": {
                  "align": {
                    "align": {
                      "named": "top_right"
                    }
                  },
                  "padding": {
                    "edgeInsets": {
                      "top": 0,
                      "right": 0,
                      "bottom": 0,
                      "left": 0,
                      "token": "lg"
                    }
                  }
                },
                "children": [
                  {
                    "type": "iconbutton",
                    "properties": {
                      "name": {
                        "icon": {
                          "name": "favorite_border_rounded"
                        }
                      },
                      "bg": {
                        "color": {
                          "color": "surface",
                          "opacityPercent": 80
                        }
                      },
                      "color": {
                        "color": {
                          "color": "error"
                        }
                      },
                      "radius": {
                        "radius": {
                          "topLeft": 0,
                          "topRight": 0,
                          "bottomLeft": 0,
                          "bottomRight": 0,
                          "token": "full"
                        }
                      },
                      "size": {
                        "numberVal": {
                          "value": 24
                        }
                      }
                    },
                    "editorId": "iconbutton6"
                  }
                ],
                "editorId": "container43"
              }
            ],
            "editorId": "stack5"
          },
          {
            "type": "column",
            "properties": {
              "padding": {
                "edgeInsets": {
                  "top": 0,
                  "right": 0,
                  "bottom": 0,
                  "left": 0,
                  "rightToken": "lg",
                  "bottomToken": "lg",
                  "leftToken": "lg"
                }
              },
              "spacing": {
                "stringVal": {
                  "value": "lg"
                }
              }
            },
            "children": [
              {
                "type": "column",
                "properties": {
                  "spacing": {
                    "stringVal": {
                      "value": "xs"
                    }
                  },
                  "cross_align": {
                    "align": {
                      "named": "start"
                    }
                  }
                },
                "children": [
                  {
                    "type": "row",
                    "properties": {
                      "spacing": {
                        "stringVal": {
                          "value": "sm"
                        }
                      }
                    },
                    "children": [
                      {
                        "type": "chip",
                        "properties": {
                          "content": {
                            "stringVal": {
                              "value": "Breakfast"
                            }
                          },
                          "bg": {
                            "color": {
                              "color": "success",
                              "opacityPercent": 15
                            }
                          },
                          "color": {
                            "color": {
                              "color": "success"
                            }
                          },
                          "radius": {
                            "radius": {
                              "topLeft": 0,
                              "topRight": 0,
                              "bottomLeft": 0,
                              "bottomRight": 0,
                              "token": "sm"
                            }
                          }
                        },
                        "editorId": "chip1"
                      },
                      {
                        "type": "row",
                        "properties": {
                          "spacing": {
                            "stringVal": {
                              "value": "xs"
                            }
                          }
                        },
                        "children": [
                          {
                            "type": "icon",
                            "properties": {
                              "name": {
                                "icon": {
                                  "name": "schedule_rounded"
                                }
                              },
                              "size": {
                                "numberVal": {
                                  "value": 16
                                }
                              },
                              "color": {
                                "color": {
                                  "color": "secondary_text"
                                }
                              }
                            },
                            "editorId": "icon19"
                          },
                          {
                            "type": "text",
                            "properties": {
                              "content": {
                                "stringVal": {
                                  "value": "15 mins"
                                }
                              },
                              "style": {
                                "textStyle": {
                                  "styleName": "label_medium"
                                }
                              },
                              "color": {
                                "color": {
                                  "color": "secondary_text"
                                }
                              }
                            },
                            "editorId": "text74"
                          }
                        ],
                        "editorId": "row31"
                      }
                    ],
                    "editorId": "row30"
                  },
                  {
                    "type": "text",
                    "properties": {
                      "content": {
                        "stringVal": {
                          "value": "Avocado & Poached Egg Toast"
                        }
                      },
                      "style": {
                        "textStyle": {
                          "styleName": "headline_medium"
                        }
                      },
                      "font_weight": {
                        "stringVal": {
                          "value": "bold"
                        }
                      },
                      "color": {
                        "color": {
                          "color": "primary_text"
                        }
                      }
                    },
                    "editorId": "text75"
                  },
                  {
                    "type": "row",
                    "properties": {
                      "spacing": {
                        "stringVal": {
                          "value": "xs"
                        }
                      },
                      "align_child": {
                        "align": {
                          "named": "center"
                        }
                      }
                    },
                    "children": [
                      {
                        "type": "icon",
                        "properties": {
                          "name": {
                            "icon": {
                              "name": "local_fire_department_rounded"
                            }
                          },
                          "size": {
                            "numberVal": {
                              "value": 20
                            }
                          },
                          "color": {
                            "color": {
                              "color": "on_background"
                            }
                          }
                        },
                        "editorId": "icon20"
                      },
                      {
                        "type": "text",
                        "properties": {
                          "content": {
                            "stringVal": {
                              "value": "450 kcal"
                            }
                          },
                          "style": {
                            "textStyle": {
                              "styleName": "title_medium"
                            }
                          },
                          "color": {
                            "color": {
                              "color": "on_background"
                            }
                          },
                          "font_weight": {
                            "numberVal": {
                              "value": 600
                            }
                          }
                        },
                        "editorId": "text76"
                      }
                    ],
                    "editorId": "row32"
                  }
                ],
                "editorId": "column58"
              },
              {
                "type": "row",
                "properties": {
                  "spacing": {
                    "stringVal": {
                      "value": "md"
                    }
                  }
                },
                "children": [
                  {
                    "type": "expanded",
                    "children": [
                      {
                        "type": "@macro_chip",
                        "properties": {
                          "label": {
                            "stringVal": {
                              "value": "Protein"
                            }
                          },
                          "value": {
                            "stringVal": {
                              "value": "18g"
                            }
                          }
                        },
                        "editorId": "macrochip1"
                      }
                    ],
                    "editorId": "expanded15"
                  },
                  {
                    "type": "expanded",
                    "children": [
                      {
                        "type": "@macro_chip",
                        "properties": {
                          "label": {
                            "stringVal": {
                              "value": "Carbs"
                            }
                          },
                          "value": {
                            "stringVal": {
                              "value": "32g"
                            }
                          }
                        },
                        "editorId": "macrochip2"
                      }
                    ],
                    "editorId": "expanded16"
                  },
                  {
                    "type": "expanded",
                    "children": [
                      {
                        "type": "@macro_chip",
                        "properties": {
                          "label": {
                            "stringVal": {
                              "value": "Fat"
                            }
                          },
                          "value": {
                            "stringVal": {
                              "value": "24g"
                            }
                          }
                        },
                        "editorId": "macrochip3"
                      }
                    ],
                    "editorId": "expanded17"
                  }
                ],
                "editorId": "row33"
              },
              {
                "type": "column",
                "properties": {
                  "spacing": {
                    "stringVal": {
                      "value": "md"
                    }
                  },
                  "cross_align": {
                    "align": {
                      "named": "start"
                    }
                  }
                },
                "children": [
                  {
                    "type": "text",
                    "properties": {
                      "content": {
                        "stringVal": {
                          "value": "Ingredients"
                        }
                      },
                      "style": {
                        "textStyle": {
                          "styleName": "title_large"
                        }
                      },
                      "font_weight": {
                        "stringVal": {
                          "value": "bold"
                        }
                      }
                    },
                    "editorId": "text77"
                  },
                  {
                    "type": "container",
                    "properties": {
                      "bg": {
                        "color": {
                          "color": "surface"
                        }
                      },
                      "radius": {
                        "radius": {
                          "topLeft": 0,
                          "topRight": 0,
                          "bottomLeft": 0,
                          "bottomRight": 0,
                          "token": "lg"
                        }
                      },
                      "padding": {
                        "edgeInsets": {
                          "top": 0,
                          "right": 0,
                          "bottom": 0,
                          "left": 0,
                          "token": "lg"
                        }
                      },
                      "border": {
                        "border": {
                          "width": 1,
                          "color": "divider"
                        }
                      },
                      "width": {
                        "px": {
                          "value": "Infinity",
                          "isInfinity": true
                        }
                      }
                    },
                    "children": [
                      {
                        "type": "column",
                        "properties": {
                          "spacing": {
                            "stringVal": {
                              "value": "sm"
                            }
                          }
                        },
                        "children": [
                          {
                            "type": "@std.checkbox",
                            "properties": {
                              "label": {
                                "stringVal": {
                                  "value": "2 slices of whole-grain bread"
                                }
                              },
                              "is_checked": {
                                "boolVal": {
                                  "value": true
                                }
                              }
                            },
                            "editorId": "ing1"
                          },
                          {
                            "type": "@std.checkbox",
                            "properties": {
                              "label": {
                                "stringVal": {
                                  "value": "1 ripe avocado"
                                }
                              },
                              "is_checked": {
                                "boolVal": {
                                  "value": true
                                }
                              }
                            },
                            "editorId": "ing2"
                          },
                          {
                            "type": "@std.checkbox",
                            "properties": {
                              "label": {
                                "stringVal": {
                                  "value": "2 large eggs"
                                }
                              },
                              "is_checked": {
                                "boolVal": {
                                  "value": false
                                }
                              }
                            },
                            "editorId": "ing3"
                          },
                          {
                            "type": "@std.checkbox",
                            "properties": {
                              "label": {
                                "stringVal": {
                                  "value": "Red pepper flakes & sea salt"
                                }
                              },
                              "is_checked": {
                                "boolVal": {
                                  "value": false
                                }
                              }
                            },
                            "editorId": "ing4"
                          },
                          {
                            "type": "@std.checkbox",
                            "properties": {
                              "label": {
                                "stringVal": {
                                  "value": "Fresh lemon juice"
                                }
                              },
                              "is_checked": {
                                "boolVal": {
                                  "value": false
                                }
                              }
                            },
                            "editorId": "ing5"
                          }
                        ],
                        "editorId": "column60"
                      }
                    ],
                    "editorId": "container44"
                  }
                ],
                "editorId": "column59"
              },
              {
                "type": "column",
                "properties": {
                  "spacing": {
                    "stringVal": {
                      "value": "md"
                    }
                  },
                  "cross_align": {
                    "align": {
                      "named": "start"
                    }
                  }
                },
                "children": [
                  {
                    "type": "text",
                    "properties": {
                      "content": {
                        "stringVal": {
                          "value": "Quick Instructions"
                        }
                      },
                      "style": {
                        "textStyle": {
                          "styleName": "title_large"
                        }
                      },
                      "font_weight": {
                        "stringVal": {
                          "value": "bold"
                        }
                      }
                    },
                    "editorId": "text78"
                  },
                  {
                    "type": "column",
                    "properties": {
                      "spacing": {
                        "stringVal": {
                          "value": "lg"
                        }
                      }
                    },
                    "children": [
                      {
                        "type": "@instruction_step",
                        "properties": {
                          "number": {
                            "stringVal": {
                              "value": "1"
                            }
                          },
                          "text": {
                            "stringVal": {
                              "value": "Toast the whole-grain bread slices until golden and crisp."
                            }
                          }
                        },
                        "editorId": "step1"
                      },
                      {
                        "type": "@instruction_step",
                        "properties": {
                          "number": {
                            "stringVal": {
                              "value": "2"
                            }
                          },
                          "text": {
                            "stringVal": {
                              "value": "In a small bowl, mash the avocado with lemon juice, salt, and pepper flakes."
                            }
                          }
                        },
                        "editorId": "step2"
                      },
                      {
                        "type": "@instruction_step",
                        "properties": {
                          "number": {
                            "stringVal": {
                              "value": "3"
                            }
                          },
                          "text": {
                            "stringVal": {
                              "value": "Bring a pot of water to a light simmer and poach the eggs for 3-4 minutes."
                            }
                          }
                        },
                        "editorId": "step3"
                      },
                      {
                        "type": "@instruction_step",
                        "properties": {
                          "number": {
                            "stringVal": {
                              "value": "4"
                            }
                          },
                          "text": {
                            "stringVal": {
                              "value": "Spread the avocado mash onto the toast and top with the poached eggs."
                            }
                          }
                        },
                        "editorId": "step4"
                      }
                    ],
                    "editorId": "column62"
                  }
                ],
                "editorId": "column61"
              },
              {
                "type": "@std.button",
                "properties": {
                  "content": {
                    "stringVal": {
                      "value": "Mark as Eaten"
                    }
                  },
                  "variant": {
                    "stringVal": {
                      "value": "primary"
                    }
                  },
                  "size": {
                    "stringVal": {
                      "value": "large"
                    }
                  },
                  "full_width": {
                    "boolVal": {
                      "value": true
                    }
                  },
                  "icon": {
                    "stringVal": {
                      "value": "check_circle_rounded"
                    }
                  }
                },
                "editorId": "stdbutton8"
              },
              {
                "type": "sizedbox",
                "properties": {
                  "height": {
                    "stringVal": {
                      "value": "lg"
                    }
                  }
                },
                "editorId": "sizedbox13"
              }
            ],
            "editorId": "column57"
          }
        ],
        "editorId": "column56"
      }
    ],
    "editorId": "scaffold9"
  }
}
```

### 10. Profile & Preferences

- Frame ID: `frame8`
- Original page prompt: "User profile screen with options to edit onboarding data and app settings"
- Follow-up prompts: _None_

#### DslDocument (JSON)

```json
{
  "root": {
    "type": "scaffold",
    "properties": {
      "bg": {
        "color": {
          "color": "background"
        }
      }
    },
    "children": [
      {
        "type": "column",
        "properties": {
          "scroll": {
            "boolVal": {
              "value": true
            }
          },
          "cross_align": {
            "align": {
              "named": "stretch"
            }
          }
        },
        "children": [
          {
            "type": "stack",
            "properties": {
              "height": {
                "px": {
                  "value": 280,
                  "isInfinity": false
                }
              }
            },
            "children": [
              {
                "type": "container",
                "properties": {
                  "height": {
                    "px": {
                      "value": 220,
                      "isInfinity": false
                    }
                  },
                  "gradient": {
                    "gradient": {
                      "type": "GRADIENT_TYPE_LINEAR",
                      "direction": "to_bottom",
                      "stops": [
                        {
                          "color": "primary"
                        },
                        {
                          "color": "primary_container"
                        }
                      ]
                    }
                  },
                  "radius": {
                    "radius": {
                      "topLeft": 0,
                      "topRight": 0,
                      "bottomLeft": 40,
                      "bottomRight": 40
                    }
                  }
                },
                "editorId": "container45"
              },
              {
                "type": "column",
                "properties": {
                  "align": {
                    "align": {
                      "named": "bottom_center"
                    }
                  },
                  "spacing": {
                    "stringVal": {
                      "value": "md"
                    }
                  }
                },
                "children": [
                  {
                    "type": "container",
                    "properties": {
                      "width": {
                        "px": {
                          "value": 110,
                          "isInfinity": false
                        }
                      },
                      "height": {
                        "px": {
                          "value": 110,
                          "isInfinity": false
                        }
                      },
                      "radius": {
                        "radius": {
                          "topLeft": 0,
                          "topRight": 0,
                          "bottomLeft": 0,
                          "bottomRight": 0,
                          "token": "full"
                        }
                      },
                      "border": {
                        "border": {
                          "width": 4,
                          "color": "surface"
                        }
                      },
                      "shadow": {
                        "stringVal": {
                          "value": "lg"
                        }
                      },
                      "clip": {
                        "boolVal": {
                          "value": true
                        }
                      }
                    },
                    "children": [
                      {
                        "type": "image",
                        "properties": {
                          "source_desc": {
                            "imageSource": {
                              "type": "IMAGE_SOURCE_TYPE_URL",
                              "value": "https://dimg.dreamflow.cloud/v1/image/friendly+person+smiling+portrait"
                            }
                          },
                          "fit": {
                            "stringVal": {
                              "value": "cover"
                            }
                          }
                        },
                        "editorId": "image3"
                      }
                    ],
                    "editorId": "container46"
                  },
                  {
                    "type": "column",
                    "properties": {
                      "spacing": {
                        "stringVal": {
                          "value": "xs"
                        }
                      }
                    },
                    "children": [
                      {
                        "type": "text",
                        "properties": {
                          "content": {
                            "stringVal": {
                              "value": "Alex Rivers"
                            }
                          },
                          "style": {
                            "textStyle": {
                              "styleName": "headline_small"
                            }
                          },
                          "font_weight": {
                            "stringVal": {
                              "value": "bold"
                            }
                          },
                          "color": {
                            "color": {
                              "color": "primary_text"
                            }
                          }
                        },
                        "editorId": "text79"
                      },
                      {
                        "type": "text",
                        "properties": {
                          "content": {
                            "stringVal": {
                              "value": "alex.rivers@example.com"
                            }
                          },
                          "style": {
                            "textStyle": {
                              "styleName": "body_medium"
                            }
                          },
                          "color": {
                            "color": {
                              "color": "secondary_text"
                            }
                          }
                        },
                        "editorId": "text80"
                      }
                    ],
                    "editorId": "column65"
                  }
                ],
                "editorId": "column64"
              }
            ],
            "editorId": "stack6"
          },
          {
            "type": "container",
            "properties": {
              "padding": {
                "edgeInsets": {
                  "top": 0,
                  "right": 0,
                  "bottom": 0,
                  "left": 0,
                  "rightToken": "lg",
                  "leftToken": "lg"
                }
              },
              "margin": {
                "edgeInsets": {
                  "top": 0,
                  "right": 0,
                  "bottom": 0,
                  "left": 0,
                  "bottomToken": "xl"
                }
              }
            },
            "children": [
              {
                "type": "container",
                "properties": {
                  "bg": {
                    "color": {
                      "color": "surface"
                    }
                  },
                  "radius": {
                    "radius": {
                      "topLeft": 0,
                      "topRight": 0,
                      "bottomLeft": 0,
                      "bottomRight": 0,
                      "token": "xl"
                    }
                  },
                  "padding": {
                    "edgeInsets": {
                      "top": 0,
                      "right": 0,
                      "bottom": 0,
                      "left": 0,
                      "token": "lg"
                    }
                  },
                  "shadow": {
                    "stringVal": {
                      "value": "sm"
                    }
                  }
                },
                "children": [
                  {
                    "type": "row",
                    "properties": {
                      "align": {
                        "align": {
                          "named": "space_around"
                        }
                      }
                    },
                    "children": [
                      {
                        "type": "@profile_stat",
                        "properties": {
                          "value": {
                            "stringVal": {
                              "value": "72.5 kg"
                            }
                          },
                          "label": {
                            "stringVal": {
                              "value": "Current"
                            }
                          }
                        },
                        "editorId": "profilestat1"
                      },
                      {
                        "type": "divider",
                        "properties": {
                          "vertical": {
                            "boolVal": {
                              "value": true
                            }
                          },
                          "thickness": {
                            "numberVal": {
                              "value": 1
                            }
                          },
                          "color": {
                            "color": {
                              "color": "divider"
                            }
                          },
                          "height": {
                            "px": {
                              "value": 30,
                              "isInfinity": false
                            }
                          }
                        },
                        "editorId": "divider1"
                      },
                      {
                        "type": "@profile_stat",
                        "properties": {
                          "value": {
                            "stringVal": {
                              "value": "68.0 kg"
                            }
                          },
                          "label": {
                            "stringVal": {
                              "value": "Target"
                            }
                          }
                        },
                        "editorId": "profilestat2"
                      },
                      {
                        "type": "divider",
                        "properties": {
                          "vertical": {
                            "boolVal": {
                              "value": true
                            }
                          },
                          "thickness": {
                            "numberVal": {
                              "value": 1
                            }
                          },
                          "color": {
                            "color": {
                              "color": "divider"
                            }
                          },
                          "height": {
                            "px": {
                              "value": 30,
                              "isInfinity": false
                            }
                          }
                        },
                        "editorId": "divider2"
                      },
                      {
                        "type": "@profile_stat",
                        "properties": {
                          "value": {
                            "stringVal": {
                              "value": "1,850"
                            }
                          },
                          "label": {
                            "stringVal": {
                              "value": "Daily Cal"
                            }
                          }
                        },
                        "editorId": "profilestat3"
                      }
                    ],
                    "editorId": "row34"
                  }
                ],
                "editorId": "container48"
              }
            ],
            "editorId": "container47"
          },
          {
            "type": "column",
            "properties": {
              "padding": {
                "edgeInsets": {
                  "top": 0,
                  "right": 0,
                  "bottom": 0,
                  "left": 0,
                  "rightToken": "lg",
                  "leftToken": "lg"
                }
              },
              "cross_align": {
                "align": {
                  "named": "stretch"
                }
              },
              "spacing": {
                "stringVal": {
                  "value": "md"
                }
              }
            },
            "children": [
              {
                "type": "row",
                "properties": {
                  "align": {
                    "align": {
                      "named": "space_between"
                    }
                  },
                  "cross_align": {
                    "align": {
                      "named": "center"
                    }
                  }
                },
                "children": [
                  {
                    "type": "text",
                    "properties": {
                      "content": {
                        "stringVal": {
                          "value": "Personal Preferences"
                        }
                      },
                      "style": {
                        "textStyle": {
                          "styleName": "title_medium"
                        }
                      },
                      "font_weight": {
                        "stringVal": {
                          "value": "bold"
                        }
                      }
                    },
                    "editorId": "text81"
                  },
                  {
                    "type": "@std.button",
                    "properties": {
                      "content": {
                        "stringVal": {
                          "value": "Retake Quiz"
                        }
                      },
                      "variant": {
                        "stringVal": {
                          "value": "ghost"
                        }
                      },
                      "size": {
                        "stringVal": {
                          "value": "small"
                        }
                      },
                      "icon": {
                        "stringVal": {
                          "value": "refresh_rounded"
                        }
                      }
                    },
                    "editorId": "stdbutton9"
                  }
                ],
                "editorId": "row35"
              },
              {
                "type": "@setting_row",
                "properties": {
                  "icon": {
                    "stringVal": {
                      "value": "target"
                    }
                  },
                  "icon_bg": {
                    "stringVal": {
                      "value": "info_container"
                    }
                  },
                  "icon_color": {
                    "stringVal": {
                      "value": "info"
                    }
                  },
                  "title": {
                    "stringVal": {
                      "value": "Health Goals"
                    }
                  },
                  "subtitle": {
                    "stringVal": {
                      "value": "Weight Loss • Muscle Gain"
                    }
                  }
                },
                "editorId": "settingrow1"
              },
              {
                "type": "@setting_row",
                "properties": {
                  "icon": {
                    "stringVal": {
                      "value": "restaurant_rounded"
                    }
                  },
                  "icon_bg": {
                    "stringVal": {
                      "value": "success_container"
                    }
                  },
                  "icon_color": {
                    "stringVal": {
                      "value": "success"
                    }
                  },
                  "title": {
                    "stringVal": {
                      "value": "Dietary Pattern"
                    }
                  },
                  "subtitle": {
                    "stringVal": {
                      "value": "Mediterranean • High Protein"
                    }
                  }
                },
                "editorId": "settingrow2"
              },
              {
                "type": "@setting_row",
                "properties": {
                  "icon": {
                    "stringVal": {
                      "value": "warning_rounded"
                    }
                  },
                  "icon_bg": {
                    "stringVal": {
                      "value": "error_container"
                    }
                  },
                  "icon_color": {
                    "stringVal": {
                      "value": "error"
                    }
                  },
                  "title": {
                    "stringVal": {
                      "value": "Allergies & Dislikes"
                    }
                  },
                  "subtitle": {
                    "stringVal": {
                      "value": "Peanuts • Shellfish • Olives"
                    }
                  }
                },
                "editorId": "settingrow3"
              },
              {
                "type": "@setting_row",
                "properties": {
                  "icon": {
                    "stringVal": {
                      "value": "fitness_center_rounded"
                    }
                  },
                  "icon_bg": {
                    "stringVal": {
                      "value": "warning_container"
                    }
                  },
                  "icon_color": {
                    "stringVal": {
                      "value": "warning"
                    }
                  },
                  "title": {
                    "stringVal": {
                      "value": "Activity Level"
                    }
                  },
                  "subtitle": {
                    "stringVal": {
                      "value": "Moderately Active (3-5 days/week)"
                    }
                  }
                },
                "editorId": "settingrow4"
              },
              {
                "type": "@setting_row",
                "properties": {
                  "icon": {
                    "stringVal": {
                      "value": "straightener_rounded"
                    }
                  },
                  "icon_bg": {
                    "stringVal": {
                      "value": "primary_container"
                    }
                  },
                  "icon_color": {
                    "stringVal": {
                      "value": "primary"
                    }
                  },
                  "title": {
                    "stringVal": {
                      "value": "Body Measurements"
                    }
                  },
                  "subtitle": {
                    "stringVal": {
                      "value": "28 years • 175 cm • Male"
                    }
                  }
                },
                "editorId": "settingrow5"
              }
            ],
            "editorId": "column66"
          },
          {
            "type": "column",
            "properties": {
              "padding": {
                "edgeInsets": {
                  "top": 0,
                  "right": 0,
                  "bottom": 0,
                  "left": 0,
                  "token": "lg"
                }
              },
              "cross_align": {
                "align": {
                  "named": "stretch"
                }
              },
              "spacing": {
                "stringVal": {
                  "value": "md"
                }
              }
            },
            "children": [
              {
                "type": "text",
                "properties": {
                  "content": {
                    "stringVal": {
                      "value": "Account Settings"
                    }
                  },
                  "style": {
                    "textStyle": {
                      "styleName": "title_medium"
                    }
                  },
                  "font_weight": {
                    "stringVal": {
                      "value": "bold"
                    }
                  }
                },
                "editorId": "text82"
              },
              {
                "type": "container",
                "properties": {
                  "bg": {
                    "color": {
                      "color": "surface"
                    }
                  },
                  "radius": {
                    "radius": {
                      "topLeft": 0,
                      "topRight": 0,
                      "bottomLeft": 0,
                      "bottomRight": 0,
                      "token": "lg"
                    }
                  },
                  "padding": {
                    "edgeInsets": {
                      "top": 0,
                      "right": 0,
                      "bottom": 0,
                      "left": 0,
                      "token": "sm"
                    }
                  },
                  "border": {
                    "border": {
                      "width": 1,
                      "color": "divider"
                    }
                  }
                },
                "children": [
                  {
                    "type": "column",
                    "properties": {
                      "spacing": {
                        "numberVal": {
                          "value": 0
                        }
                      }
                    },
                    "children": [
                      {
                        "type": "@setting_row",
                        "properties": {
                          "icon": {
                            "stringVal": {
                              "value": "notifications_active_rounded"
                            }
                          },
                          "icon_bg": {
                            "stringVal": {
                              "value": "surface_variant"
                            }
                          },
                          "icon_color": {
                            "stringVal": {
                              "value": "secondary_text"
                            }
                          },
                          "title": {
                            "stringVal": {
                              "value": "Notifications"
                            }
                          },
                          "subtitle": {
                            "stringVal": {
                              "value": "Meal reminders & Weekly reports"
                            }
                          }
                        },
                        "editorId": "settingrow6"
                      },
                      {
                        "type": "divider",
                        "properties": {
                          "color": {
                            "color": {
                              "color": "divider"
                            }
                          },
                          "margin": {
                            "edgeInsets": {
                              "top": 0,
                              "right": 0,
                              "bottom": 0,
                              "left": 0,
                              "rightToken": "md",
                              "leftToken": "md"
                            }
                          }
                        },
                        "editorId": "divider3"
                      },
                      {
                        "type": "@setting_row",
                        "properties": {
                          "icon": {
                            "stringVal": {
                              "value": "lock_rounded"
                            }
                          },
                          "icon_bg": {
                            "stringVal": {
                              "value": "surface_variant"
                            }
                          },
                          "icon_color": {
                            "stringVal": {
                              "value": "secondary_text"
                            }
                          },
                          "title": {
                            "stringVal": {
                              "value": "Privacy & Security"
                            }
                          },
                          "subtitle": {
                            "stringVal": {
                              "value": "Manage your data and account"
                            }
                          }
                        },
                        "editorId": "settingrow7"
                      },
                      {
                        "type": "divider",
                        "properties": {
                          "color": {
                            "color": {
                              "color": "divider"
                            }
                          },
                          "margin": {
                            "edgeInsets": {
                              "top": 0,
                              "right": 0,
                              "bottom": 0,
                              "left": 0,
                              "rightToken": "md",
                              "leftToken": "md"
                            }
                          }
                        },
                        "editorId": "divider4"
                      },
                      {
                        "type": "@setting_row",
                        "properties": {
                          "icon": {
                            "stringVal": {
                              "value": "help_outline_rounded"
                            }
                          },
                          "icon_bg": {
                            "stringVal": {
                              "value": "surface_variant"
                            }
                          },
                          "icon_color": {
                            "stringVal": {
                              "value": "secondary_text"
                            }
                          },
                          "title": {
                            "stringVal": {
                              "value": "Help Center"
                            }
                          },
                          "subtitle": {
                            "stringVal": {
                              "value": "FAQ and Support"
                            }
                          }
                        },
                        "editorId": "settingrow8"
                      }
                    ],
                    "editorId": "column68"
                  }
                ],
                "editorId": "container49"
              }
            ],
            "editorId": "column67"
          },
          {
            "type": "container",
            "properties": {
              "padding": {
                "edgeInsets": {
                  "top": 0,
                  "right": 0,
                  "bottom": 0,
                  "left": 0,
                  "token": "lg"
                }
              },
              "margin": {
                "edgeInsets": {
                  "top": 0,
                  "right": 0,
                  "bottom": 0,
                  "left": 0,
                  "bottomToken": "xl"
                }
              }
            },
            "children": [
              {
                "type": "@std.button",
                "properties": {
                  "content": {
                    "stringVal": {
                      "value": "Sign Out"
                    }
                  },
                  "variant": {
                    "stringVal": {
                      "value": "outline"
                    }
                  },
                  "full_width": {
                    "boolVal": {
                      "value": true
                    }
                  },
                  "icon": {
                    "stringVal": {
                      "value": "logout_rounded"
                    }
                  },
                  "color": {
                    "stringVal": {
                      "value": "error"
                    }
                  }
                },
                "editorId": "stdbutton10"
              }
            ],
            "editorId": "container50"
          },
          {
            "type": "sizedbox",
            "properties": {
              "height": {
                "stringVal": {
                  "value": "lg"
                }
              }
            },
            "editorId": "sizedbox14"
          }
        ],
        "editorId": "column63"
      }
    ],
    "editorId": "scaffold10"
  }
}
```