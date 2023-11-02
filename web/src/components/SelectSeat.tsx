import React, { useEffect, useState } from "react";
import "./SelectSeat.css";
import Header from "./Header";
import NextButton from "./NextButton";
import MovieScreen from "../assets/screen.webp";
import Row from "./Row";

type SelectSeatProps = {
    setSelectedSeats: (seats: Array<TheatreSeat>) => void;
    grid: TheatreGrid;
    movieName: string;
};

export type TheatreSeat = {
    id: number;
    row: number;
    reserved: boolean;
    blank: boolean;
    selected: boolean;
    price: number;
};

export type TheatreRow = {
    id: number;
    seats: Array<TheatreSeat>;
    blank: boolean;
};

export type TheatreGrid = {
    rows: Array<TheatreRow>;
};

function useForceUpdate() {
    const [value, setValue] = useState(0);
    return () => setValue((value) => value + 1);
    // idk about another solution, this is hack to force a re-render xd
}

const SelectSeat: React.FC<SelectSeatProps> = ({
    setSelectedSeats,
    grid,
    movieName,
}) => {
    const [seats, setSeats] = useState<Array<TheatreSeat>>([]);
    const forceUpdate = useForceUpdate();
    return (
        <>
            <Header
                title="Vyberte místa"
                description="Prosím, vyberte si Vaše místa."
                movieName={movieName}
            ></Header>
            <hr></hr>
            <div className="legend">
                <div className="legend-item">
                    <div className="empty-square"></div>
                    <span>Dostupné</span>
                </div>
                <div className="legend-item">
                    <div className="reserved-square"></div>
                    <span>Nedostupné</span>
                </div>
                <div className="legend-item">
                    <div className="selected-square"></div>
                    <span>Váš výběr</span>
                </div>
            </div>
            <div className="seat-selector">
                <img src={MovieScreen} className="screen-image" />
                <div className="seats">
                    {grid.rows.map((row) => {
                        return (
                            <Row
                                id={row.id}
                                seats={row.seats}
                                blank={row.blank}
                                select={(seat) => {
                                    forceUpdate();
                                    seat.selected = !seat.selected;
                                    if (seats.includes(seat)) {
                                        console.log("Removing seat");
                                        seats.splice(seats.indexOf(seat), 1);
                                    } else {
                                        console.log("Adding seat");
                                        seats.push(seat);
                                    }
                                }}
                            />
                        );
                    })}
                </div>
            </div>
            <NextButton
                text="Další"
                color="orange"
                action={() => {
                    console.log("Selected seats:");
                    console.dir(seats);
                    setSelectedSeats(seats);
                }}
            />
        </>
    );
};

export default SelectSeat;
