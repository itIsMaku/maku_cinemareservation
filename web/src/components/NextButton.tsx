import React, { useState } from "react";
import "./NextButton.css";
import cn from "classnames";

type NextButtonProps = {
    action: () => void;
    text: string;
    color: string;
};

const NextButton: React.FC<NextButtonProps> = ({ action, text, color }) => {
    return (
        <div className="next">
            <button
                className={cn("next-button", color)}
                onClick={() => {
                    action();
                }}
            >
                {text}
            </button>
        </div>
    );
};

export default NextButton;
