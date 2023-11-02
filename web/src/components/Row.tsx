import React, { useEffect, useState } from "react";
import "./Row.css";
import { TheatreRow, TheatreSeat } from "./SelectSeat";
import cn from "classnames";

type RowProps = {
    id: number;
    seats: Array<TheatreSeat>;
    blank: boolean;
    select: (seat: TheatreSeat) => void;
};

const Row: React.FC<RowProps> = ({ id, seats, blank, select }) => {
    return (
        <div className="theatre-row">
            <div className="row-number">{id}</div>
            <div className="row-seats">
                {seats.map((seat) => {
                    return (
                        <div
                            className={cn("theatre-seat", {
                                blank: seat.blank,
                                reserved: seat.reserved,
                                selected: seat.selected,
                            })}
                            key={seat.id}
                            onClick={() => {
                                if (!seat.blank && !seat.reserved) {
                                    select(seat);
                                }
                            }}
                        >
                            <span className="number">
                                {seat.blank ? "" : seat.id}
                            </span>
                        </div>
                    );
                })}
            </div>
            <div className="row-number">{id}</div>
        </div>
    );
};

export default Row;
