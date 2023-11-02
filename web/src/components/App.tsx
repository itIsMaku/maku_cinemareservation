import React, { useState } from "react";
import "./App.css";
import { debugData } from "../utils/debugData";
import TransactionType from "./TransactionType";
import SelectSeat, { TheatreGrid, TheatreRow, TheatreSeat } from "./SelectSeat";
import { useNuiEvent } from "../hooks/useNuiEvent";
import Payment from "./Payment";

debugData([
    {
        action: "setVisible",
        data: true,
    },
]);

const App: React.FC = () => {
    const [movie, setMovie] = useState<string>("");
    const [theatre, setTheatre] = useState<string>("");

    const [transactionType, setTransactionType] = useState<string>("");
    const [selectedSeats, setSelectedSeats] = useState<
        Array<TheatreSeat> | undefined
    >(undefined);
    const [grid, setGrid] = useState<TheatreGrid>({ rows: [] });

    useNuiEvent<{
        grid: TheatreGrid;
        movie: string;
        theatre: string;
    }>("showSelection", (data) => {
        setGrid(data.grid);
        setMovie(data.movie);
        setTheatre(data.theatre);
    });

    useNuiEvent<{}>("clear", () => {
        setMovie("");
        setTransactionType("");
        setSelectedSeats(undefined);
        setGrid({ rows: [] });
        setTheatre("");
    });

    return (
        <div className="nui-wrapper">
            <div className="system-wrapper">
                {transactionType === "" ? (
                    <TransactionType
                        setTransactionType={setTransactionType}
                        movieName={movie}
                    />
                ) : (
                    <>
                        {selectedSeats === undefined ? (
                            <SelectSeat
                                setSelectedSeats={(seats) => {
                                    setSelectedSeats(seats);
                                }}
                                grid={grid}
                                movieName={movie}
                            />
                        ) : (
                            <Payment
                                seats={selectedSeats}
                                movieName={movie}
                                theatre={theatre}
                            />
                        )}
                    </>
                )}
            </div>
        </div>
    );
};

export default App;
